# Dashboard Summary

**Base URL:** `http://api.lokas-tubes-abp.test/api`

> Endpoint ini memerlukan Bearer Token.

---

## `GET /dashboard/summary`

Ringkasan agregat untuk kebutuhan dashboard web admin.

**Response `200`:**

```json
{
  "success": true,
  "data": {
    "totals": {
      "items": 148,
      "categories": 12,
      "warehouses": 3,
      "users": 9
    },
    "items_by_status": {
      "available": 102,
      "borrowed": 34,
      "maintenance": 12
    },
    "loans_by_status": {
      "pending": 7,
      "active": 34,
      "returned": 120,
      "overdue": 3,
      "rejected": 4
    },
    "alerts_active": {
      "overdue": 3,
      "due_soon": 5,
      "not_returned": 1,
      "total": 9
    },
    "category_status": [
      {
        "id": 1,
        "name": "Elektronik",
        "total_items": 48,
        "available_items": 30,
        "borrowed_items": 15,
        "maintenance_items": 3
      }
    ]
  }
}
```
