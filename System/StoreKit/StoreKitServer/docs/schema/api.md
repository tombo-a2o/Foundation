## <a name="resource-product"></a>Product

Product for sale

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **created_at** | *date-time* | when product was created | `"2015-01-01T12:00:00Z"` |
| **id** | *integer* | unique identifier of product | `42` |
| **updated_at** | *date-time* | when product was updated | `"2015-01-01T12:00:00Z"` |
| **product_identifier** | *string* | unique identifier of product<br/> **pattern:** <code>^[A-Za-z0-9_.]+$</code> | `"com.example.iap.coins.100"` |
| **localized_description** | *string* | description of product | `"example"` |
| **localized_title** | *string* | title of product | `"example"` |
| **price** | *integer* | price of product | `42` |
| **price_locale** | *string* | locale of product''s price | `"example"` |
| **downloadable** | *boolean* | downloadable flag of product | `true` |
| **download_content_lengths** | *array* | content lengths of downloadable product | `[null]` |
| **download_content_version** | *integer* | version of downloadable product | `42` |

### Product Create

Create a new product.

```
POST /products
```


#### Curl Example

```bash
$ curl -n -X POST http://api.tombo.io//products \
  -H "Content-Type: application/json" \
 \
  -d '{
}'
```


#### Response Example

```
HTTP/1.1 201 Created
```

```json
{
  "created_at": "2015-01-01T12:00:00Z",
  "id": 42,
  "updated_at": "2015-01-01T12:00:00Z",
  "product_identifier": "com.example.iap.coins.100",
  "localized_description": "example",
  "localized_title": "example",
  "price": 42,
  "price_locale": "example",
  "downloadable": true,
  "download_content_lengths": [
    null
  ],
  "download_content_version": 42
}
```

### Product Delete

Delete an existing product.

```
DELETE /products/{product_id_or_product_identifier}
```


#### Curl Example

```bash
$ curl -n -X DELETE http://api.tombo.io//products/$PRODUCT_ID_OR_PRODUCT_IDENTIFIER \
  -H "Content-Type: application/json" \
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "created_at": "2015-01-01T12:00:00Z",
  "id": 42,
  "updated_at": "2015-01-01T12:00:00Z",
  "product_identifier": "com.example.iap.coins.100",
  "localized_description": "example",
  "localized_title": "example",
  "price": 42,
  "price_locale": "example",
  "downloadable": true,
  "download_content_lengths": [
    null
  ],
  "download_content_version": 42
}
```

### Product Info

Info for existing product.

```
GET /products/{product_id_or_product_identifier}
```


#### Curl Example

```bash
$ curl -n http://api.tombo.io//products/$PRODUCT_ID_OR_PRODUCT_IDENTIFIER
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "created_at": "2015-01-01T12:00:00Z",
  "id": 42,
  "updated_at": "2015-01-01T12:00:00Z",
  "product_identifier": "com.example.iap.coins.100",
  "localized_description": "example",
  "localized_title": "example",
  "price": 42,
  "price_locale": "example",
  "downloadable": true,
  "download_content_lengths": [
    null
  ],
  "download_content_version": 42
}
```

### Product List

List existing products.

```
GET /products
```


#### Curl Example

```bash
$ curl -n http://api.tombo.io//products
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
[
  {
    "created_at": "2015-01-01T12:00:00Z",
    "id": 42,
    "updated_at": "2015-01-01T12:00:00Z",
    "product_identifier": "com.example.iap.coins.100",
    "localized_description": "example",
    "localized_title": "example",
    "price": 42,
    "price_locale": "example",
    "downloadable": true,
    "download_content_lengths": [
      null
    ],
    "download_content_version": 42
  }
]
```

### Product Update

Update an existing product.

```
PATCH /products/{product_id_or_product_identifier}
```


#### Curl Example

```bash
$ curl -n -X PATCH http://api.tombo.io//products/$PRODUCT_ID_OR_PRODUCT_IDENTIFIER \
  -H "Content-Type: application/json" \
 \
  -d '{
}'
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "created_at": "2015-01-01T12:00:00Z",
  "id": 42,
  "updated_at": "2015-01-01T12:00:00Z",
  "product_identifier": "com.example.iap.coins.100",
  "localized_description": "example",
  "localized_title": "example",
  "price": 42,
  "price_locale": "example",
  "downloadable": true,
  "download_content_lengths": [
    null
  ],
  "download_content_version": 42
}
```


