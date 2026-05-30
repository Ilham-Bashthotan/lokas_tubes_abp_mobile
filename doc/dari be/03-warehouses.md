# Warehouses

**Base URL:** `http://api.lokas-tubes-abp.test/api`

> Semua endpoint memerlukan Bearer Token. Endpoint yang bertanda *(Admin only)* hanya bisa diakses oleh pengguna dengan role `admin`.

---

## Skema Warehouse

```json
{
  "id": 1,
  "name": "Gudang Utama A",
  "address": "Jl. Industri No. 10, Jakarta",
  "latitude": -6.2088,
  "longitude": 106.8456,
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

| Field | Tipe | Keterangan |
|---|---|---|
| `id` | integer | |
| `name` | string | |
| `address` | string | |
| `latitude` | float | |
| `longitude` | float | |
| `created_at` | datetime | |
| `updated_at` | datetime | |

---

## `GET /warehouses`

Daftar semua gudang.

**Query Parameters:**

| Parameter | Tipe | Keterangan |
|---|---|---|
| `search` | string | Cari berdasarkan name atau address |
| `sort_by` | enum | `name` \| `address` \| `created_at` \| `updated_at` |
| `sort_dir` | enum | `asc` \| `desc` (default: `desc`) |

**Response `200`:**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Gudang Utama A",
      "address": "Jl. Industri No. 10, Jakarta",
      "latitude": "-6.2088000",
      "longitude": "106.8456000",
      "created_at": "2026-03-26T19:24:42.000000Z",
      "updated_at": "2026-03-26T19:24:42.000000Z"
    }
  ]
}
```

---

## `POST /warehouses`

Tambah gudang baru. *(Admin only)*

**Request Body:**

```json
{
  "name": "Gudang B - Selatan",
  "address": "Jl. Raya Bogor KM 20",
  "latitude": -6.5123,
  "longitude": 106.9234
}
```

| Field | Wajib | Keterangan |
|---|---|---|
| `name` | ✅ | |
| `address` | ✅ | |
| `latitude` | ✅ | |
| `longitude` | ✅ | |

**Response `201`:**

```json
{
  "success": true,
  "message": "Warehouse created successfully",
  "data": {
    "id": 2,
    "name": "Gudang B - Selatan",
    "address": "Jl. Raya Bogor KM 20",
    "latitude": "-6.5123000",
    "longitude": "106.9234000",
    "created_at": "2026-04-06T12:30:00.000000Z",
    "updated_at": "2026-04-06T12:30:00.000000Z"
  }
}
```

**Response `422`:** Validasi gagal.

```json
{
  "success": false,
  "errors": {
    "name": ["The name field is required."]
  }
}
```

---

## `GET /warehouses/{id}`

Detail gudang.

**Response `200`:**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Gudang Utama A",
    "address": "Jl. Industri No. 10, Jakarta",
    "latitude": "-6.2088000",
    "longitude": "106.8456000",
    "created_at": "2026-03-26T19:24:42.000000Z",
    "updated_at": "2026-03-26T19:24:42.000000Z"
  }
}
```

**Response `404`:** Gudang tidak ditemukan.

---

## `PUT /warehouses/{id}`

Update gudang. *(Admin only)*

**Request Body (semua field opsional):**

```json
{
  "name": "Gudang B - Selatan Updated",
  "address": "Jl. Raya Bogor KM 25",
  "latitude": -6.5200,
  "longitude": 106.9300
}
```

**Response `200`:**

```json
{
  "success": true,
  "message": "Warehouse updated successfully",
  "data": {
    "id": 2,
    "name": "Gudang B - Selatan Updated",
    "address": "Jl. Raya Bogor KM 25",
    "latitude": "-6.5200000",
    "longitude": "106.9300000",
    "created_at": "2026-04-06T12:30:00.000000Z",
    "updated_at": "2026-04-06T13:00:00.000000Z"
  }
}
```

**Response `404`:** Gudang tidak ditemukan.

**Response `422`:** Validasi gagal.

---

## `DELETE /warehouses/{id}`

Hapus gudang. *(Admin only)*

**Response `200`:**

```json
{
  "success": true,
  "message": "Warehouse deleted successfully"
}
```

**Response `404`:** Gudang tidak ditemukan.

**Response `422`:** Gudang masih dipakai item.

```json
{
  "success": false,
  "message": "Cannot delete warehouse that is still used by items"
}
```
