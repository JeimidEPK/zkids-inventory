Asi funciona:

1. Obtenemos todos los productos creados en la tienda de Shopify
2. Obtenemos los productos en el backend de EPK
3. Actualizamos el producto si:
  a. El producto existe en Shopify
  b. Las cantidades son diferentes en Shopify y en EPK
  c. El producto en la tienda Shopify tiene habilidata la opcion para ser actualizado

Para que el sincronizador funcione debemos configurar
1. s_api_key: la llave de acceso a la tienda via API
2. s_password: la contraseña de acceso a la tienda via API
3. s_store: Nombre de la tienda
4. admin_mail: Correo del administrador para envirar los resultado
