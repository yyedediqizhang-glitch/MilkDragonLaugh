# EDU SNAP

A Flutter demo app built during the **Mobile App Development with Flutter**
workshop (EDUHK, Itchi Technology Limited), structured with the MVC layout
taught in Session 1.

## Folder structure

```
lib/
├── main.dart                 # app entry, MaterialApp
├── models/                   # data classes only (no widgets, no network)
│   └── snap_item.dart
├── components/               # reusable widgets
│   ├── primary_button.dart
│   └── snap_card.dart
├── pages/                    # one folder per page: view + controller
│   ├── landing_page/
│   │   ├── landing_page_view.dart
│   │   └── landing_page_controller.dart
│   └── home_page/
│       ├── home_page_view.dart
│       └── home_page_controller.dart
└── util/                     # shared helpers
    ├── app_theme.dart
    ├── date_formatter.dart
    └── network_controller.dart
```

## MVC in one line

* **Model** – plain data (`SnapItem`)
* **View** – what the user sees (`*_view.dart`)
* **Controller** – page state and logic (`*_controller.dart`, a `ChangeNotifier`)

## Run it

```bash
flutter pub get
flutter run          # choose a device, e.g. Chrome or Windows
flutter test         # widget test for the landing -> home flow
```

## Session 1 checklist

- [x] Flutter project created
- [x] MVC folders (`models`, `components`, `pages`, `util`)
- [x] Landing page (view + controller)
- [x] Home page (view + controller)
- [x] Committed and pushed to GitHub
