## <a name="resource-product"></a>Product

Product for sale

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **data/created_at** | *date-time* | when product was created | `"2015-01-01T12:34:56.789Z"` |
| **data/download_content_lengths** | *array* | content lengths of downloadable product | `[]` |
| **data/download_content_version** | *integer* | version of downloadable product | `0` |
| **data/downloadable** | *boolean* | downloadable flag of product | `false` |
| **data/localized_description** | *string* | description of product | `"description of product"` |
| **data/localized_title** | *string* | title of product | `"title of product"` |
| **data/price** | *integer* | price of product | `100` |
| **data/price_locale** | *string* | locale of product''s price | `"en_US"` |
| **data/product_identifier** | *string* | unique identifier of product<br/> **pattern:** <code>^[A-Za-z0-9_.]+$</code> | `"com.example.iap.coins.100"` |
| **data/updated_at** | *date-time* | when product was updated | `"2015-01-01T12:34:56.789Z"` |

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
      "localized_description": "description of product",
      "localized_title": "title of product",
      "price": 100,
      "price_locale": "en_US",
      "downloadable": false,
      "download_content_lengths": [

      ],
      "download_content_version": 0,
      "created_at": "2015-01-01T12:34:56.789Z",
      "updated_at": "2015-01-01T12:34:56.789Z"
    }
  ]
}
```


