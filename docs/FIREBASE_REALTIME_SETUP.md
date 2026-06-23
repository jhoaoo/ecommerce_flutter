# Firebase realtime setup

This phase requires Firebase Auth, Firestore and Storage rules to be deployed.

## Required Firebase console settings

1. Firebase Authentication:
   - Enable Email/Password.
   - Enable Google provider.
   - Add your web domain to authorized domains.

2. Firestore:
   - Use Native mode.
   - Deploy `firestore.rules`.

3. Storage:
   - Deploy `storage.rules`.

## Deploy commands

```bash
firebase login
firebase use ecommerce-7ea77
firebase deploy --only firestore:rules,storage
```

## First admin

The email `jhoaoollerena@gmail.com` is treated as the owner account. Sign in with that Google/email account first so the app creates the admin profile.

## Validation checklist

- Register a new user.
- Create a role request as seller.
- Login as admin and approve the request.
- Login as seller, create a product and verify it is pending.
- Login as admin, approve the product.
- Login as customer and confirm the product appears in the catalog.
- Create an order and verify stock changes in realtime.
