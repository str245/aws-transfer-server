# Transfer Server Terraform Module

Es un modulo que despliega el servicio en AWS, de transfer server

## Uso

Para desplegar un usuario valido es necesario informar del siguiente atributo para el acceso a los ficheros de origen **public_key** esta variable tiene que tener el formato de RSA

### Ejemplo de Uso

```hcl
module "aws_sftp" {
  source     = "git::ssh://git@code.company.com/core/aws-transfer-server?ref=X.X.X"
  tags       = "${var.tags}"
  public_key = "${var.sfpt_public_key}"
  home_directory = "${var.home_directory}"
  account_number = "${var.account_number}"
}
```

### PECULIARIDAD DEL MODULO

-se saca un output llamado "sftp_cname" que informa del valor o nombre el registro DNS que se debe de crear a mano desde el AWS tranfer Family en la seccion Endpoint Details >> Custom hostname. editando las propiedades y creando un hostname de tipo "Amazon Route53 DNS alias"

## Ejemplo de configuracion

-Recurso: aws_transfer_server
Proporciona un recurso de servidor de transferencia de AWS.

```hcl
resource "aws_transfer_server" "example" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = aws_iam_role.example.arn

  tags = {
    NAME = "tf-acc-test-transfer-server"
    ENV  = "test"
  }
}

resource "aws_iam_role" "example" {
  name = "tf-test-transfer-server-iam-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "example" {
  name = "tf-test-transfer-server-iam-policy"
  role = aws_iam_role.example.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "AllowFullAccesstoCloudWatchLogs",
        "Effect": "Allow",
        "Action": [
            "logs:*"
        ],
        "Resource": "*"
        }
    ]
}
POLICY
}
```

Referencia de argumento
Se admiten los siguientes argumentos:

## Parameters

- **endpoint_details**- (Opcional) La configuración del punto final de la nube privada virtual (VPC) que desea configurar para su servidor SFTP. Campos       documentados a continuación.
- **endpoint_type**- (Opcional) El tipo de punto final al que desea que se conecte su servidor SFTP. Si se conecta a VPC(o VPC_ENDPOINT), su servidor SFTP no es accesible a través de la Internet pública. Si desea conectar su servidor SFTP a través de Internet público, configure PUBLIC. Por defecto es PUBLIC.
- **invocation_role**- (Opcional) Nombre de recurso de Amazon (ARN) del rol de IAM utilizado para autenticar la cuenta de usuario con una identity_provider_typede API_GATEWAY.
- **host_key**- (Opcional) Clave privada RSA (por ejemplo, la generada por el ssh-keygen -N "" -m PEM -f my-new-server-keycomando).
- **url**- (Opcional): URL del punto final del servicio que se utiliza para autenticar a los usuarios con una identity_provider_typede API_GATEWAY.
- **identity_provider_type**- (Opcional) El modo de autenticación habilitado para este servicio. El valor predeterminado es SERVICE_MANAGED, que le permite almacenar y acceder a las credenciales de usuario de SFTP dentro del servicio. API_GATEWAYindica que la autenticación de usuario requiere una llamada a una URL de punto final de API Gateway proporcionada por usted para integrar un proveedor de identidad de su elección.
- **logging_role** - (Opcional) Nombre de recurso de Amazon (ARN) de un rol de IAM que permite al servicio escribir la actividad de sus usuarios de SFTP en sus registros de Amazon CloudWatch para fines de supervisión y auditoría.
- **force_destroy**- (Opcional) Un booleano que indica que todos los usuarios asociados con el servidor deben eliminarse para que el servidor pueda destruirse sin errores. El valor predeterminado es false.
- **tags** - (Opcional) Un mapa de etiquetas para asignar al recurso.


**endpoint_details requiere lo siguiente:**

- **vpc_endpoint_id**- (Opcional) El ID del punto final de la VPC. Esta propiedad solo se puede utilizar cuando endpoint_typese establece enVPC_ENDPOINT
- **address_allocation_ids**- (Opcional) Una lista de ID de asignación de direcciones que se requieren para adjuntar una dirección IP elástica al punto final de su servidor SFTP. Esta propiedad solo se puede utilizar cuando endpoint_typese establece en VPC.
- **subnet_ids**- (Opcional) Una lista de los ID de subred necesarios para alojar el punto final de su servidor SFTP en su VPC. Esta propiedad solo se puede utilizar cuando endpoint_typese establece en VPC.
- **vpc_id**- (Opcional) El ID de VPC de la nube privada virtual en la que se alojará el punto final del servidor SFTP. Esta propiedad solo se puede utilizar cuando endpoint_typese establece en VPC.

## Outputs

Referencia de atributos u Outputs:

Además de todos los argumentos anteriores, se exportan los siguientes atributos:

- **arn** - Nombre de recurso de Amazon (ARN) del servidor de transferencia
- **id** - El ID de servidor del servidor de transferencia (p s-12345678. Ej. )
- **endpoint**- El punto final del servidor de transferencia (p s-12345678.server.transfer.REGION.amazonaws.com. Ej. )
- **host_key_fingerprint**- Este valor contiene el hash del algoritmo de resumen de mensajes (MD5) de la clave de host del servidor. Este valor es equivalente a la salida del ssh-keygen -l -E md5 -f my-new-server-keycomando.
