## <a name="resource-product"></a>Product

Product for sale

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **data/created_at** | *date-time* | when product was created | `"2015-01-01T12:00:00Z"` |
| **data/download_content_lengths** | *array* | content lengths of downloadable product | `[null]` |
| **data/download_content_version** | *integer* | version of downloadable product | `42` |
| **data/downloadable** | *boolean* | downloadable flag of product | `true` |
| **data/localized_description** | *string* | description of product | `"example"` |
| **data/localized_title** | *string* | title of product | `"example"` |
| **data/price** | *integer* | price of product | `42` |
| **data/price_locale** | *string* | locale of product''s price | `"example"` |
| **data/product_identifier** | *string* | unique identifier of product<br/> **pattern:** <code>^[A-Za-z0-9_.]+$</code> | `"com.example.iap.coins.100"` |
| **data/updated_at** | *date-time* | when product was updated | `"2015-01-01T12:00:00Z"` |

### Product 

List existing products.

```
GET /products
```


#### Curl Example

```bash
$ curl -n http://api.tombo.io/products
```


#### Response Example

```
HTTP/1.1 200 OK
```

```json
{
  "data": [
    {
      "product_identifier": "com.example.iap.coins.100",
      "localized_description": "example",
      "localized_title": "example",
      "price": 42,
      "price_locale": "example",
      "downloadable": true,
      "download_content_lengths": [
        null
      ],
      "download_content_version": 42,
      "created_at": "2015-01-01T12:00:00Z",
      "updated_at": "2015-01-01T12:00:00Z"
    }
  ]
}
```


