# Items

**Base URL:** `http://api.lokas-tubes-abp.test/api`

> Semua endpoint memerlukan Bearer Token. Endpoint yang bertanda *(Admin only)* hanya bisa diakses oleh pengguna dengan role `admin`.

---

## Skema Item

```json
{
  "id": 1,
  "name": "Laptop Dell XPS 13",
  "description": "Laptop untuk kebutuhan presentasi",
  "qr_code": "INV-2024-001",
  "image_url": "https://cdn.inventorytrack.test/items/laptop-dell.jpg",
  "condition": "good",
  "status": "available",
  "category": {
    "id": 2,
    "name": "Elektronik"
  },
  "warehouse": {
    "id": 3,
    "name": "Gudang Utama",
    "address": "Jl. Raya No. 1",
    "latitude": -6.2000000,
    "longitude": 106.8166667
  },
  "active_loan": {
    "id": 12,
    "borrower": "Staff Gudang",
    "loan_date": "2026-04-01",
    "due_date": "2026-04-05"
  },
  "created_at": "2026-04-01 08:00:00",
  "updated_at": "2026-04-01 08:00:00"
}
```

| Field | Tipe | Keterangan |
|---|---|---|
| `id` | integer | |
| `name` | string | |
| `description` | string \| null | |
| `qr_code` | string | Kode unik barang |
| `image_url` | string \| null | URL foto barang |
| `condition` | enum | `good` \| `damaged` \| `lost` |
| `status` | enum | `available` \| `borrowed` \| `maintenance` |
| `category` | object \| null | Objek kategori ringkas |
| `warehouse` | object \| null | Objek gudang ringkas |
| `active_loan` | object \| null | Loan aktif ringkas jika ada |
| `created_at` | datetime | |
| `updated_at` | datetime | |

---

## `GET /items`

Daftar semua barang inventaris.

**Query Parameters:**

| Parameter | Tipe | Keterangan |
|---|---|---|
| `status` | enum | `available` \| `borrowed` \| `maintenance` |
| `condition` | enum | `good` \| `damaged` \| `lost` |
| `category_id` | integer | Filter berdasarkan kategori |
| `warehouse_id` | integer | Filter berdasarkan gudang |
| `search` | string | Cari berdasarkan nama atau QR code |
| `sort_by` | enum | `name` \| `qr_code` \| `status` \| `condition` \| `created_at` \| `updated_at` |
| `sort_dir` | enum | `asc` \| `desc` (default: `desc`) |
| `page` | integer | Default: `1` |
| `per_page` | integer | Default: `15` |

**Response `200`:**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Laptop Dell XPS 13",
      "description": "Laptop untuk kebutuhan presentasi",
      "qr_code": "INV-2024-001",
      "image_url": "/storage/items/laptop-dell.jpg",
      "condition": "good",
      "status": "available",
      "category": {
        "id": 2,
        "name": "Elektronik"
      },
      "warehouse": {
        "id": 3,
        "name": "Gudang Utama",
        "address": "Jl. Raya No. 1",
        "latitude": -6.2000000,
        "longitude": 106.8166667
      },
      "active_loan": null,
      "created_at": "2026-04-01 08:00:00",
      "updated_at": "2026-04-01 08:00:00"
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 15,
    "total": 100,
    "last_page": 7
  }
}
```

---

## `POST /items`

Tambah barang baru. *(Admin only)*

> Content-Type: `multipart/form-data`

**Request Body:**

| Field | Wajib | Tipe | Keterangan |
|---|---|---|---|
| `name` | ✅ | string | |
| `category_id` | ✅ | integer | |
| `warehouse_id` | ✅ | integer | |
| `qr_code` | ✅ | string | Contoh: `INV-2024-010` |
| `description` | ❌ | string | |
| `condition` | ❌ | enum | `good` \| `damaged` \| `lost` — Default: `good` |
| `status` | ❌ | enum | `available` \| `borrowed` \| `maintenance` |
| `image` | ❌ | file | jpg/png, maks 2MB |

**Response `201`:**

```json
{
  "success": true,
  "message": "Item created successfully",
  "data": {
    "id": 10,
    "name": "Proyektor Epson",
    "description": "Untuk presentasi",
    "qr_code": "INV-2026-005",
    "image_url": "/storage/items/proyektor.jpg",
    "condition": "good",
    "status": "available",
    "category": {
      "id": 2,
      "name": "Elektronik"
    },
    "warehouse": {
      "id": 3,
      "name": "Gudang Utama",
      "address": "Jl. Raya No. 1",
      "latitude": -6.2000000,
      "longitude": 106.8166667
    },
    "active_loan": null,
    "created_at": "2026-04-04 07:45:00",
    "updated_at": "2026-04-04 07:45:00"
  }
}
```

**Response `422`:** Validasi gagal.

```json
{
  "success": false,
  "errors": {
    "name": ["Nama barang wajib diisi."]
  }
}
```

---

## `GET /items/{id}`

Detail barang inventaris.

**Response `200`:**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Laptop Dell XPS 13",
    "description": "Laptop untuk kebutuhan presentasi",
    "qr_code": "INV-2024-001",
    "image_url": "/storage/items/laptop-dell.jpg",
    "condition": "good",
    "status": "available",
    "category": {
      "id": 2,
      "name": "Elektronik"
    },
    "warehouse": {
      "id": 3,
      "name": "Gudang Utama",
      "address": "Jl. Raya No. 1",
      "latitude": -6.2000000,
      "longitude": 106.8166667
    },
    "active_loan": null,
    "created_at": "2026-04-01 08:00:00",
    "updated_at": "2026-04-01 08:00:00"
  }
}
```

**Response `404`:** Barang tidak ditemukan.

---

## `PUT /items/{id}`

Update data barang. *(Admin only)*

> Content-Type: `multipart/form-data`

**Request Body (semua field opsional):**

| Field | Tipe | Keterangan |
|---|---|---|
| `name` | string | |
| `description` | string | |
| `category_id` | integer | |
| `warehouse_id` | integer | |
| `qr_code` | string | |
| `condition` | enum | `good` \| `damaged` \| `lost` |
| `status` | enum | `available` \| `borrowed` \| `maintenance` |
| `image` | file | jpg/png, maks 2MB |

**Response `200`:**

```json
{
  "success": true,
  "message": "Item updated successfully",
  "data": {
    "id": 1,
    "name": "Laptop Dell XPS 13 Updated",
    "description": "Laptop untuk kebutuhan presentasi",
    "qr_code": "INV-2024-001",
    "image_url": "/storage/items/laptop-dell-updated.jpg",
    "condition": "good",
    "status": "available",
    "category": {
      "id": 2,
      "name": "Elektronik"
    },
    "warehouse": {
      "id": 3,
      "name": "Gudang Utama",
      "address": "Jl. Raya No. 1",
      "latitude": -6.2000000,
      "longitude": 106.8166667
    },
    "active_loan": null,
    "created_at": "2026-04-01 08:00:00",
    "updated_at": "2026-04-04 08:30:00"
  }
}
```

**Response `404`:** Barang tidak ditemukan.

---

## `DELETE /items/{id}`

Hapus barang. *(Admin only)*

**Response `200`:**

```json
{
  "success": true,
  "message": "Item deleted successfully"
}
```

**Response `404`:** Barang tidak ditemukan.

**Response `422`:** Barang sedang dipinjam.

```json
{
  "success": false,
  "message": "Cannot delete item that is currently being borrowed"
}
```

---

## `GET /items/qr/{qr_code}`

Cari barang berdasarkan QR Code. *(Untuk scan mobile)*

**Contoh:** `GET /items/qr/INV-2024-001`

**Response `200`:**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Laptop Dell XPS 13",
    "description": "Laptop untuk kebutuhan presentasi",
    "qr_code": "INV-2024-001",
    "image_url": "/storage/items/laptop-dell.jpg",
    "condition": "good",
    "status": "available",
    "category": {
      "id": 2,
      "name": "Elektronik"
    },
    "warehouse": {
      "id": 3,
      "name": "Gudang Utama",
      "address": "Jl. Raya No. 1",
      "latitude": -6.2000000,
      "longitude": 106.8166667
    },
    "active_loan": null,
    "created_at": "2026-04-01 08:00:00",
    "updated_at": "2026-04-01 08:00:00"
  },
  "can_borrow": true
}
```

**Response `404`:** Barang dengan QR Code tersebut tidak ditemukan.
