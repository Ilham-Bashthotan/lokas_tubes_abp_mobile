# Loans

**Base URL:** `http://api.lokas-tubes-abp.test/api`

> Semua endpoint memerlukan Bearer Token. Endpoint yang bertanda *(Admin only)* hanya bisa diakses oleh pengguna dengan role `admin`.

---

## Skema Loan

```json
{
  "id": 1,
  "item_id": 1,
  "item": {
    "id": 1,
    "name": "Laptop Dell XPS 13",
    "qr_code": "INV-2024-001",
    "status": "borrowed",
    "condition": "good"
  },
  "borrower_id": 8,
  "borrower": { /* User */ },
  "approved_by": 2,
  "approver": { /* User | null */ },
  "loan_date": "2024-11-01",
  "due_date": "2024-11-07",
  "return_date": null,
  "status": "active",
  "note": "Untuk keperluan rapat direksi",
  "photo_before": "https://cdn.inventorytrack.test/loans/before-1.jpg",
  "photo_after": null,
  "created_at": "2024-11-01T08:00:00Z"
}
```

| Field | Tipe | Keterangan |
|---|---|---|
| `id` | integer | |
| `item` | object | Data ringkas barang |
| `borrower_id` | integer | ID peminjam (disembunyikan untuk non-admin) |
| `borrower` | User | Data peminjam (disembunyikan untuk non-admin) |
| `approved_by` | integer \| null | ID admin yang menyetujui |
| `approver` | User \| null | Data admin yang menyetujui |
| `loan_date` | date | Tanggal pinjam |
| `due_date` | date | Batas waktu pengembalian |
| `return_date` | date \| null | Tanggal dikembalikan |
| `status` | enum | `pending` \| `active` \| `returned` \| `overdue` \| `rejected` |
| `note` | string \| null | Catatan |
| `photo_before` | string \| null | URL foto sebelum dipinjam |
| `photo_after` | string \| null | URL foto setelah dikembalikan |
| `created_at` | datetime | |

---

## `GET /loans`

Daftar semua peminjaman.

**Query Parameters:**

| Parameter | Tipe | Keterangan |
|---|---|---|
| `status` | enum | `pending` \| `active` \| `returned` \| `overdue` \| `rejected` |
| `borrower_id` | integer | Filter peminjam *(admin only)* |
| `item_id` | integer | Filter barang |
| `from_date` | date | Format: `YYYY-MM-DD` |
| `to_date` | date | Format: `YYYY-MM-DD` |
| `sort_by` | enum | `created_at` \| `loan_date` \| `due_date` \| `return_date` \| `status` |
| `sort_dir` | enum | `asc` \| `desc` (default: `desc`) |
| `page` | integer | Default: `1` |
| `per_page` | integer | Default: `15` |

Catatan:
- Non-admin tetap dapat melihat daftar semua loan, tetapi field `borrower` dan `borrower_id` disembunyikan dari response.
- Filter `borrower_id` hanya dapat digunakan oleh admin.

**Response `200`:**

```json
{
  "success": true,
  "data": [
    {
      "id": 12,
      "item_id": 3,
      "item": {
        "id": 3,
        "name": "Laptop Lenovo ThinkPad",
        "qr_code": "INV-2026-003",
        "status": "borrowed",
        "condition": "good"
      },
      "borrower_id": 8,
      "borrower": {
        "id": 8,
        "name": "Staff Gudang",
        "email": "staff.gudang@example.com",
        "role": "staff"
      },
      "approved_by": 2,
      "approver": {
        "id": 2,
        "name": "Admin Utama",
        "email": "admin@example.com",
        "role": "admin"
      },
      "loan_date": "2026-04-01",
      "due_date": "2026-04-05",
      "return_date": null,
      "status": "active",
      "note": "Keperluan inventaris mingguan",
      "photo_before": "/storage/loans/before/sample-before.jpg",
      "photo_after": null,
      "created_at": "2026-04-01T09:00:00.000000Z",
      "updated_at": "2026-04-02T10:00:00.000000Z"
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

## `POST /loans`

Buat permohonan peminjaman baru.

> Content-Type: `multipart/form-data`

**Request Body:**

| Field | Wajib | Tipe | Keterangan |
|---|---|---|---|
| `item_id` | ✅ | integer | ID barang yang ingin dipinjam |
| `loan_date` | ✅ | date | Format: `YYYY-MM-DD` |
| `due_date` | ✅ | date | Format: `YYYY-MM-DD` |
| `note` | ❌ | string | |
| `photo_before` | ❌ | file | Foto kondisi barang sebelum dipinjam |

**Response `201`:**

```json
{
  "success": true,
  "message": "Loan request submitted successfully",
  "data": {
    "id": 20,
    "item_id": 5,
    "borrower_id": 8,
    "borrower": {
      "id": 8,
      "name": "Staff Gudang",
      "email": "staff.gudang@example.com",
      "role": "staff"
    },
    "approved_by": null,
    "approver": null,
    "item": {
      "id": 5,
      "name": "Proyektor Epson",
      "qr_code": "INV-2026-005",
      "status": "available",
      "condition": "good"
    },
    "loan_date": "2026-04-04",
    "due_date": "2026-04-10",
    "return_date": null,
    "status": "pending",
    "note": "Dipakai untuk presentasi",
    "photo_before": "/storage/loans/before/sample-before-20.jpg",
    "photo_after": null,
    "created_at": "2026-04-04T07:45:00.000000Z",
    "updated_at": "2026-04-04T07:45:00.000000Z"
  }
}
```

**Response `409`:** Barang tidak tersedia.

```json
{
  "success": false,
  "message": "Item is currently not available for borrowing"
}
```

**Response `422`:** Validasi gagal.

---

## `GET /loans/{id}`

Detail peminjaman.

**Response `200`:**

```json
{
  "success": true,
  "data": {
    "id": 12,
    "item_id": 3,
    "item": {
      "id": 3,
      "name": "Laptop Lenovo ThinkPad",
      "qr_code": "INV-2026-003",
      "status": "borrowed",
      "condition": "good"
    },
    "borrower_id": 8,
    "borrower": {
      "id": 8,
      "name": "Staff Gudang",
      "email": "staff.gudang@example.com",
      "role": "staff"
    },
    "approved_by": 2,
    "approver": {
      "id": 2,
      "name": "Admin Utama",
      "email": "admin@example.com",
      "role": "admin"
    },
    "loan_date": "2026-04-01",
    "due_date": "2026-04-05",
    "return_date": null,
    "status": "active",
    "note": "Keperluan inventaris mingguan",
    "photo_before": "/storage/loans/before/sample-before.jpg",
    "photo_after": null,
    "created_at": "2026-04-01T09:00:00.000000Z",
    "updated_at": "2026-04-02T10:00:00.000000Z"
  }
}
```

**Response `404`:** Peminjaman tidak ditemukan.

---

## `PATCH /loans/{id}/approve`

Approve permohonan peminjaman. *(Admin only)*

Status loan akan berubah dari `pending` → `active`.

**Response `200`:**

```json
{
  "success": true,
  "message": "Loan approved successfully",
  "data": {
    "id": 12,
    "item_id": 3,
    "borrower_id": 8,
    "borrower": {
      "id": 8,
      "name": "Staff Gudang",
      "email": "staff.gudang@example.com",
      "role": "staff"
    },
    "approved_by": 2,
    "approver": {
      "id": 2,
      "name": "Admin Utama",
      "email": "admin@example.com",
      "role": "admin"
    },
    "item": {
      "id": 3,
      "name": "Laptop Lenovo ThinkPad",
      "qr_code": "INV-2026-003",
      "status": "borrowed",
      "condition": "good"
    },
    "loan_date": "2026-04-01",
    "due_date": "2026-04-05",
    "return_date": null,
    "status": "active",
    "note": "Keperluan inventaris mingguan",
    "photo_before": "/storage/loans/before/sample-before.jpg",
    "photo_after": null,
    "created_at": "2026-04-01T09:00:00.000000Z",
    "updated_at": "2026-04-04T08:30:00.000000Z"
  }
}
```

**Response `400`:** Loan bukan status `pending`.

```json
{
  "success": false,
  "message": "Only pending loans can be approved"
}
```

---

## `PATCH /loans/{id}/reject`

Tolak permohonan peminjaman. *(Admin only)*

**Request Body (opsional):**

```json
{
  "reason": "Barang sedang dalam proses perbaikan"
}
```

**Response `200`:**

```json
{
  "success": true,
  "message": "Loan rejected"
}
```

---

## `PATCH /loans/{id}/return`

Proses pengembalian barang.

> Content-Type: `multipart/form-data`

**Request Body:**

| Field | Wajib | Tipe | Keterangan |
|---|---|---|---|
| `condition_after` | ✅ | enum | `good` \| `damaged` |
| `note` | ❌ | string | |
| `photo_after` | ❌ | file | Foto kondisi barang setelah dikembalikan |

**Response `200`:**

```json
{
  "success": true,
  "message": "Item returned successfully",
  "data": {
    "id": 12,
    "item_id": 3,
    "borrower_id": 8,
    "borrower": {
      "id": 8,
      "name": "Staff Gudang",
      "email": "staff.gudang@example.com",
      "role": "staff"
    },
    "approved_by": 2,
    "approver": {
      "id": 2,
      "name": "Admin Utama",
      "email": "admin@example.com",
      "role": "admin"
    },
    "item": {
      "id": 3,
      "name": "Laptop Lenovo ThinkPad",
      "qr_code": "INV-2026-003",
      "status": "available",
      "condition": "good"
    },
    "loan_date": "2026-04-01",
    "due_date": "2026-04-05",
    "return_date": "2026-04-04",
    "status": "returned",
    "note": "Dikembalikan dalam kondisi baik",
    "photo_before": "/storage/loans/before/sample-before.jpg",
    "photo_after": "/storage/loans/after/sample-after.jpg",
    "created_at": "2026-04-01T09:00:00.000000Z",
    "updated_at": "2026-04-04T11:20:00.000000Z"
  }
}
```

**Response `400`:** Loan tidak dalam status `active`.

```json
{
  "success": false,
  "message": "Only active loans can be returned"
}
```

---

## `GET /loans/my`

Riwayat peminjaman milik pengguna yang sedang login.

**Query Parameters:**

| Parameter | Tipe | Keterangan |
|---|---|---|
| `status` | enum | `pending` \| `active` \| `returned` \| `overdue` \| `rejected` |
| `sort_by` | enum | `created_at` \| `loan_date` \| `due_date` \| `return_date` \| `status` |
| `sort_dir` | enum | `asc` \| `desc` (default: `desc`) |
| `page` | integer | Default: `1` |

**Response `200`:**

```json
{
  "success": true,
  "data": [
    {
      "id": 20,
      "item_id": 5,
      "item": {
        "id": 5,
        "name": "Proyektor Epson",
        "qr_code": "INV-2026-005",
        "status": "available",
        "condition": "good"
      },
      "borrower_id": 8,
      "borrower": {
        "id": 8,
        "name": "Staff Gudang",
        "email": "staff.gudang@example.com",
        "role": "staff"
      },
      "approved_by": null,
      "approver": null,
      "loan_date": "2026-04-04",
      "due_date": "2026-04-10",
      "return_date": null,
      "status": "pending",
      "note": "Dipakai untuk presentasi",
      "photo_before": "/storage/loans/before/sample-before-20.jpg",
      "photo_after": null,
      "created_at": "2026-04-04T07:45:00.000000Z",
      "updated_at": "2026-04-04T07:45:00.000000Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 15,
    "total": 1,
    "last_page": 1
  }
}
```
