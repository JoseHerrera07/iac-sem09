# Laboratorio 09: Configuración de AWS y GitHub Actions con OIDC

iac-sem09 |  JoseHerrera07 |  us-east-2 (Ohio)

## 1. Qué se pidió

Configurar AWS y GitHub para que **GitHub Actions despliegue infraestructura con Terraform sin guardar claves de AWS** (`AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY`).

Para lograrlo se usa **OIDC con un rol de IAM**: GitHub Actions pide un token temporal y AWS lo cambia por credenciales de corta duración para ese rol.

Este informe sigue los 4 puntos del documento de la tarea y muestra lo que se hizo en cada uno.

## 2. Datos usados en el laboratorio

| Dato | Valor |
|---|---|
| Región | us-east-2 |
| Bucket del estado de Terraform | `lab09-tfstate-josemh-000245501` |
| Clave del estado | `lab09/dev/terraform.tfstate` |
| Proveedor OIDC | `token.actions.githubusercontent.com` |
| Rol de despliegue | `lab09-github-actions-dev` |
| Política de permisos del rol | `lab09-terraform-dev-politica` |
| Entorno de GitHub | `dev` |
| Rama de despliegue | `development` |

## 3. Punto 1: Preparar la cuenta de AWS

| Requisito del documento | Qué se hizo |
|---|---|
| Activar MFA y no crear access keys | Se activó MFA (aplicación de autenticación) en el usuario `josemh`. En la sección de claves de acceso hay 0 |
| Usar un usuario administrativo, no root | Todo se hizo con el usuario `josemh`, no con root |
| Elegir una región | Se eligió **us-east-2** para todos los recursos |
| Alerta de presupuesto | Presupuesto mensual `lab09-presupuesto` de 10 USD con aviso por correo |
| Prefijo y entorno `dev` | Todos los recursos usan el prefijo `lab09-` y el entorno `dev` |
| Bucket S3 para el estado | Se creó `lab09-tfstate-josemh-000245501` con **acceso público bloqueado, cifrado SSE-S3 y versionado habilitado** |

El bucket es la "memoria" de Terraform: ahí anota qué creó, para saber qué cambiar o borrar la próxima vez.

## 4. Punto 2: Registrar el proveedor OIDC de GitHub en IAM

Se creó un proveedor de identidad en **IAM > Proveedores de identidad** con estos valores:

- **Tipo:** OpenID Connect
- **URL:** `https://token.actions.githubusercontent.com`
- **Público (audience):** `sts.amazonaws.com`

Con esto AWS aprende a confiar en los tokens que emite GitHub Actions.

## 5. Punto 3: Crear el rol de despliegue

Se creó el rol **`lab09-github-actions-dev`** con dos partes.

### Política de confianza (quién puede usar el rol)

Solo acepta tokens de **este repositorio, desde el entorno `dev`**, con el formato de IDs inmutables que pide el documento:

```
repo:JoseHerrera07@<ID_USUARIO>/iac-sem09@<ID_REPOSITORIO>:environment:dev
```

No se usaron comodines (`*`) en esa condición. Los IDs numéricos se obtuvieron de la API pública de GitHub. El archivo de referencia está en `docs/iam-trust-policy.json`.

### Política de permisos (qué puede hacer el rol)

Se creó una **política administrada por el cliente** llamada `lab09-terraform-dev-politica`. **No se usó AdministratorAccess.** Incluye solo lo necesario:

- Leer y escribir **únicamente** el estado de Terraform en el bucket (`lab09/dev/terraform.tfstate` y su archivo de bloqueo).
- Crear y borrar la red, los grupos de seguridad, el balanceador, el Auto Scaling, la base de datos y la caché, limitado a la región us-east-2.
- Gestionar el rol de las instancias y usar `iam:PassRole` **solo** para ese rol y **solo** hacia EC2.

El archivo de referencia está en `docs/iam-permissions-policy.json`.

## 6. Punto 4: Configurar el repositorio de GitHub

### Entorno `dev`

En **Settings > Environments** se creó el entorno `dev` con:

- **Regla de rama:** solo puede desplegar desde `development`.
- **Aprobación requerida:** cada despliegue espera a que el revisor lo apruebe antes de entrar a AWS.
- No se permiten despliegues desde forks.

### Variables del entorno

| Variable | Valor |
|---|---|
| `AWS_REGION` | `us-east-2` |
| `AWS_ROLE_ARN` | ARN del rol `lab09-github-actions-dev` |
| `TF_STATE_BUCKET` | `lab09-tfstate-josemh-000245501` |

Son **variables**, no secretos, porque ninguna es una credencial.

### Los workflows

| Workflow | Cuándo se ejecuta | Qué hace |
|---|---|---|
| `terraform-validate.yml` | En pull requests | Revisa el formato y la sintaxis. **No usa credenciales de AWS** |
| `terraform-deploy.yml` | Solo con push a `development` | Entra a AWS con OIDC y ejecuta init, validate, plan y apply |
| `terraform-destroy.yml` | Solo manual | Elimina la infraestructura. Pide escribir `destroy` para confirmar |

El workflow de despliegue cumple lo que pide el documento:

- Usa el entorno `dev`.
- Declara solo los permisos mínimos: `contents: read` e `id-token: write`.
- Obtiene las credenciales con `aws-actions/configure-aws-credentials`.
- Guarda el estado con la clave fija `lab09/dev/terraform.tfstate`.
- Las validaciones de pull request **nunca** asumen el rol de despliegue.

## 7. Infraestructura usada para probar el flujo

Como el proyecto aún no tenía código, se escribió con Terraform (en módulos) la capa de cómputo, para comprobar que el flujo funciona de punta a punta:

| Módulo | Qué crea |
|---|---|
| `network` | VPC, 6 subredes en 2 zonas, Internet Gateway, NAT Gateway y rutas |
| `security` | 4 grupos de seguridad encadenados |
| `alb` | Application Load Balancer con health check |
| `compute` | Auto Scaling Group con 2 a 6 servidores EC2 |
| `database` | RDS PostgreSQL cifrada, con la contraseña en Secrets Manager |
| `cache` | ElastiCache Redis cifrada |

```
.github/workflows/   Los 3 workflows
terraform/           Configuración principal
terraform/modules/   Un módulo por componente
docs/                Políticas de IAM de referencia
```

## 8. Resultado del despliegue (apply)

1. Primer despliegue con la configuración vacía: comprobó que GitHub entra a AWS por OIDC y que el estado se guarda en S3 (`0 added`).
2. Después se desplegó cada componente en su propio commit: red, seguridad y balanceador, servidores, base de datos y Redis.
3. Cada despliegue esperó la aprobación del revisor y terminó en verde en la pestaña **Actions**.
4. Al final, la URL del balanceador respondió desde los servidores.

## 9. Problemas encontrados y soluciones

| Qué pasó | Por qué | Cómo se resolvió |
|---|---|---|
| Error al crear el balanceador | El rol no tenía el permiso `ec2:GetSecurityGroupsForVpc` | Se agregó a la política y se reintentó |
| Error al crear el Auto Scaling Group | AWS aún no tenía lista su cuenta de servicio interna | Se esperó unos minutos y se reintentó |
| Error al crear RDS | Faltaban permisos de KMS y de Secrets Manager | Se agregaron ambos bloques a la política |

En todos los casos el código estaba bien. Faltaban permisos, y el documento ya lo anticipaba: la política se ajusta al implementar cada recurso. Se agregó solo lo necesario, sin dar permisos de administrador.

En el documento solo se presenta uno de los errores ya que en el desarrollo y la solucion de los demas se me paso el incluirlos en el documento.

## 10. Destrucción de la infraestructura (destroy)

Para evitar costos (el NAT Gateway, el balanceador, las instancias, RDS y Redis cobran por hora), se destruyó todo con el workflow manual:

1. **Actions > Terraform Destroy dev > Run workflow**.
2. Elegir la rama `development`.
3. Escribir `destroy` y confirmar.
4. Aprobar el despliegue del entorno `dev`.
5. Comprobar en la consola de AWS que no queda ningún recurso.

## 11. Evidencias

Las capturas de pantalla de cada punto, la URL del repositorio, las ejecuciones en verde de **apply** y **destroy** y la comprobación en la consola de AWS están en el informe en PDF.

## 12. Uso local (opcional)

Para ejecutar Terraform desde una PC en la cuenta del laboratorio:

```sh
cp terraform/backend.hcl.example terraform/backend.hcl   # editar el bucket
terraform -chdir=terraform init -backend-config=backend.hcl
terraform -chdir=terraform validate
terraform -chdir=terraform plan
```

El archivo `backend.hcl` está en el `.gitignore` y no se sube al repositorio.

## Referencias oficiales

- [GitHub: configurar OpenID Connect en AWS](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws)
- [AWS IAM: crear un proveedor OIDC](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html)
- [AWS IAM: configurar un rol para GitHub OIDC](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html)
- [GitHub: administrar entornos de despliegue](https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments)
