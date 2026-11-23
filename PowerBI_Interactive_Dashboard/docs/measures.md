# Power Query and DAX Reference

Power Query (M) code for each table, followed by the DAX measures used in the Olist dashboard.

## Power Query (M) queries

### customers

```m
let
  Source = Csv.Document(File.Contents("E:\Adil\Datasets\OlistDataset_PowerBI_Dashboard\olist_customers_dataset.csv"), [Delimiter = ",", Columns = 5, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"customer_id", type text}, {"customer_unique_id", type text}, {"customer_zip_code_prefix", Int64.Type}, {"customer_city", type text}, {"customer_state", type text}}, "en-US")
in
  #"Changed column type"
```

### order_items

```m
let
  Source = Csv.Document(File.Contents("E:\Adil\Datasets\OlistDataset_PowerBI_Dashboard\olist_order_items_dataset.csv"), [Delimiter = ",", Columns = 7, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"order_id", type text}, {"order_item_id", Int64.Type}, {"product_id", type text}, {"seller_id", type text}, {"shipping_limit_date", type datetime}, {"price", type number}, {"freight_value", type number}}, "en-US")
in
  #"Changed column type"
```

### order_payments

```m
let
  Source = Csv.Document(File.Contents("E:\Adil\Datasets\OlistDataset_PowerBI_Dashboard\olist_order_payments_dataset.csv"), [Delimiter = ",", Columns = 5, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"order_id", type text}, {"payment_sequential", Int64.Type}, {"payment_type", type text}, {"payment_installments", Int64.Type}, {"payment_value", type number}}, "en-US")
in
  #"Changed column type"
```

### order_reviews

```m
let
  Source = Csv.Document(File.Contents("E:\Adil\Datasets\OlistDataset_PowerBI_Dashboard\olist_order_reviews_dataset.csv"), [Delimiter = ",", Columns = 7, Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"review_id", type text}, {"order_id", type text}, {"review_score", Int64.Type}, {"review_comment_title", type text}, {"review_comment_message", type text}, {"review_creation_date", type datetime}, {"review_answer_timestamp", type datetime}}, "en-US")
in
  #"Changed column type"
```

### orders

```m
let
  Source = Csv.Document(File.Contents("E:\Adil\Datasets\OlistDataset_PowerBI_Dashboard\olist_orders_dataset.csv"), [Delimiter = ",", Columns = 8, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"order_id", type text}, {"customer_id", type text}, {"order_status", type text}, {"order_purchase_timestamp", type datetime}, {"order_approved_at", type datetime}, {"order_delivered_carrier_date", type datetime}, {"order_delivered_customer_date", type datetime}, {"order_estimated_delivery_date", type datetime}}, "en-US"),
  #"Inserted date" = Table.AddColumn(#"Changed column type", "Date", each DateTime.Date([order_purchase_timestamp]), type nullable date),
  #"Renamed columns" = Table.RenameColumns(#"Inserted date", {{"Date", "purchase_date"}}),
  #"Added custom" = Table.AddColumn(#"Renamed columns", "delivery_days", each Duration.Days([order_delivered_customer_date] - [order_purchase_timestamp])),
  #"Added custom 1" = Table.AddColumn(#"Added custom", "IsLate", each if [order_delivered_customer_date] = null then null else if [order_delivered_customer_date] > [order_estimated_delivery_date] then 1 else 0),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Added custom 1", {{"IsLate", Int64.Type}, {"delivery_days", Int64.Type}, {"purchase_date", type date}})
in
  #"Changed column type 1"
```

### products

```m
let
  Source = Csv.Document(File.Contents("E:\Adil\Datasets\OlistDataset_PowerBI_Dashboard\olist_products_dataset.csv"), [Delimiter = ",", Columns = 9, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{" ", type text}, {"product_category_name", type text}, {"product_name_length", Int64.Type}, {"product_description_length", Int64.Type}, {"product_photos_qty", Int64.Type}, {"product_weight_g", Int64.Type}, {"                                       m                                       ", Int64.Type}, {"product_height_cm", Int64.Type}, {"product_width_cm", Int64.Type}}, "en-US"),
  #"Merged queries" = Table.NestedJoin(#"Changed column type", {"product_category_name"}, category_name_translation, {"product_category_name"}, "category_name_translation", JoinKind.LeftOuter),
  #"Expanded category_name_translation" = Table.ExpandTableColumn(#"Merged queries", "category_name_translation", {"product_category_name_english"}, {"product_category_name_english"}),
  #"Renamed columns" = Table.RenameColumns(#"Expanded category_name_translation", {{"product_category_name_english", "category"}}),
  #"Reordered columns" = Table.ReorderColumns(#"Renamed columns", {" ", "product_category_name", "category", "product_name_length", "product_description_length", "product_photos_qty", "product_weight_g", "                                       m                                       ", "product_height_cm", "product_width_cm"}),
  #"Renamed columns 1" = Table.RenameColumns(#"Reordered columns", {{" ", "product_id"}, {"                                       m                                       ", "product_length_cm"}})
in
  #"Renamed columns 1"
```

### sellers

```m
let
  Source = Csv.Document(File.Contents("E:\Adil\Datasets\OlistDataset_PowerBI_Dashboard\olist_sellers_dataset.csv"), [Delimiter = ",", Columns = 4, Encoding = 65001, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"seller_id", type text}, {"seller_zip_code_prefix", Int64.Type}, {"seller_city", type text}, {"seller_state", type text}}, "en-US")
in
  #"Changed column type"
```

## DAX measures

```dax
Total Revenue = SUM(order_items[price])
Total Freight = SUM(order_items[freight_value])
Total Orders = DISTINCTCOUNT(orders[order_id])
Avg Order Value = DIVIDE([Total Revenue], [Total Orders])
Unique Customers = DISTINCTCOUNT(customers[customer_unique_id])
Avg Review Score = AVERAGE(reviews[review_score])
Avg Delivery Days = AVERAGE(orders[Delivery Days])
% Late Deliveries = AVERAGE(orders[Is Late])
Revenue Last Month = CALCULATE([Total Revenue], DATEADD('Calendar'[Date], -1, MONTH))
Revenue MoM % = DIVIDE([Total Revenue] - [Revenue Last Month], [Revenue Last Month])
```
