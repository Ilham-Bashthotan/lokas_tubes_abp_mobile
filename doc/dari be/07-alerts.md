# Alerts

**Base URL:** `http://api.lokas-tubes-abp.test/api`

> Semua endpoint hanya bisa diakses oleh pengguna dengan role `admin`.

---

## Cara Kerja

Sistem otomatis mendeteksi peminjaman bermasalah berdasarkan rule berikut:

| Tipe | Kondisi |
|---|---|
| `overdue` | `due_date` < hari ini & belum dikembalikan |
| `due_soon` | `due_date` = besok & belum dikembalikan |
| `not_returned` | Belum dikembalikan > 3 hari setelah `due_date` |

Alert dibuat otomatis via **scheduled job setiap hari pukul 00.00**, atau bisa di-trigger manual menggunakan endpoint `/alerts/check`.

---

## Skema LoanAlert

```json
{
  "id": 1,
  "loan": { /* Loan */ },
  "type": "overdue",
  "message": "Laptop Dell XPS 13 telah melewati batas waktu pengembalian 3 hari",
  "is_resolved": false,
  "alerted_at": "2024-11-10T00:00:00Z"
}
```

| Field | Tipe | Keterangan |
|---|---|---|
| `id` | integer | |
| `loan` | object | Data peminjaman terkait |
| `type` | enum | `overdue` \| `due_soon` \| `not_returned` |
| `message` | string | Pesan deskriptif alert |
| `is_resolved` | boolean | `true` jika sudah ditangani |
| `alerted_at` | datetime | Waktu alert dibuat |

---

## `GET /alerts`

Daftar semua alert. *(Admin only)*

**Query Parameters:**

| Parameter | Tipe | Keterangan |
|---|---|---|
| `type` | enum | `overdue` \| `due_soon` \| `not_returned` |
| `is_resolved` | boolean | `false` = aktif, `true` = sudah selesai |
| `sort_by` | enum | `alerted_at` \| `type` \| `created_at` \| `updated_at` |
| `sort_dir` | enum | `asc` \| `desc` (default: `desc`) |
| `page` | integer | Default: `1` |
| `per_page` | integer | Default: `15`, max: `100` |

Catatan:
- Jika `is_resolved` tidak dikirim, endpoint akan mengembalikan alert aktif (`is_resolved = false`).

**Response `200`:**

```json
{
  "success": true,
  "summary": {
    "overdue": 3,
    "due_soon": 5,
    "not_returned": 1,
    "total": 9
  },
  "data": [
    {
      "id": 7,
      "loan_id": 12,
      "type": "overdue",
      "message": "Barang 'Laptop Lenovo ThinkPad' milik Staff Gudang telah melewati batas pengembalian sejak 2026-04-02.",
      "is_resolved": false,
      "alerted_at": "2026-04-06 00:00:00",
      "created_at": "2026-04-06T00:00:00.000000Z",
      "updated_at": "2026-04-06T00:00:00.000000Z",
      "loan": {
        "id": 12,
        "item_id": 3,
        "borrower_id": 8,
        "approved_by": 2,
        "loan_date": "2026-04-01",
        "due_date": "2026-04-02",
        "return_date": null,
        "status": "active",
        "note": "Keperluan inventaris mingguan",
        "photo_before": "/storage/loans/before/sample-before.jpg",
        "photo_after": null,
        "created_at": "2026-04-01T09:00:00.000000Z",
        "updated_at": "2026-04-02T10:00:00.000000Z",
        "item": {
          "id": 3,
          "name": "Laptop Lenovo ThinkPad",
          "description": "Laptop operasional",
          "qr_code": "INV-2026-003",
          "image_url": "/storage/items/lenovo.jpg",
          "condition": "good",
          "status": "borrowed",
          "created_at": "2026-03-26T19:25:42.000000Z",
          "updated_at": "2026-04-01T09:00:00.000000Z"
        },
        "borrower": {
          "id": 8,
          "name": "Staff Gudang",
          "email": "staff.gudang@example.com",
          "role": "staff",
          "created_at": "2026-03-14T06:27:05.000000Z",
          "updated_at": "2026-03-14T06:27:05.000000Z"
        }
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 15,
    "total": 9,
    "last_page": 1
  }
}
```

---

## `PATCH /alerts/{id}/resolve`

Tandai alert sebagai resolved. *(Admin only)*

**Response `200`:**

```json
{
  "success": true,
  "message": "Alert resolved successfully",
  "data": {
    "id": 7,
    "loan_id": 12,
    "type": "overdue",
    "message": "Barang 'Laptop Lenovo ThinkPad' milik Staff Gudang telah melewati batas pengembalian sejak 2026-04-02.",
    "is_resolved": true,
    "alerted_at": "2026-04-06 00:00:00",
    "created_at": "2026-04-06T00:00:00.000000Z",
    "updated_at": "2026-04-06T12:00:00.000000Z",
    "loan": {
      "id": 12,
      "item_id": 3,
      "borrower_id": 8,
      "approved_by": 2,
      "loan_date": "2026-04-01",
      "due_date": "2026-04-02",
      "return_date": null,
      "status": "active",
      "note": "Keperluan inventaris mingguan",
      "photo_before": "/storage/loans/before/sample-before.jpg",
      "photo_after": null,
      "created_at": "2026-04-01T09:00:00.000000Z",
      "updated_at": "2026-04-02T10:00:00.000000Z",
      "item": {
        "id": 3,
        "name": "Laptop Lenovo ThinkPad",
        "description": "Laptop operasional",
        "qr_code": "INV-2026-003",
        "image_url": "/storage/items/lenovo.jpg",
        "condition": "good",
        "status": "borrowed",
        "created_at": "2026-03-26T19:25:42.000000Z",
        "updated_at": "2026-04-01T09:00:00.000000Z"
      },
      "borrower": {
        "id": 8,
        "name": "Staff Gudang",
        "email": "staff.gudang@example.com",
        "role": "staff",
        "created_at": "2026-03-14T06:27:05.000000Z",
        "updated_at": "2026-03-14T06:27:05.000000Z"
      }
    }
  }
}
```

**Response `409`:** Alert sudah resolved sebelumnya.

```json
{
  "success": false,
  "message": "Alert is already resolved."
}
```

**Response `404`:** Alert tidak ditemukan.

---

## `POST /alerts/check`

Trigger manual pengecekan overdue. *(Admin only / via cron)*

Menjalankan rule engine secara manual untuk membuat alert baru berdasarkan kondisi peminjaman saat ini.

**Response `200`:**

```json
{
  "success": true,
  "message": "4 new alerts created successfully.",
  "new_alerts_count": 4
}
```
