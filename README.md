# Mobile Information Systems Lab. Exercise 3

## Favorite meals
Saving and accessing the user's favorite meals is handled in: `\lib\services\favorite_meals_service.dart`.
Each meal thats favorited is saved by it's id and is stored on the user's device using the shared_preferences depencency.

### Home page
The Appbar has a button that redirects the user to `/favorites` where their favorite meals are shown.

### Favorites page
The user's favorite meals are pulled from favorite_meals_service and displayed from oldest to newest.

### Meal page
On each meal's page there's a button on the bottom right that indicates if the meal in the users list of favorite meals.

<br />

## Notifications
Notifications are configured to work with **Android** in: `\lib\services\notification_service.dart`.
Emulator used: API 36.0 "Baklava"; Android 16.0

#### Testing notifications
1.Go to: `\lib\screens\home.dart`
<br />

2.Go to line 104 and uncomment the following:
            
            //  -------- FOR TESTING LOCAL NOTIFICATIONS --------
            ElevatedButton(
              onPressed: () async {
                String mealId = await MealService.getRandomMeal();
                NotificationService.showNotification(payload: mealId);
                },
              child: const Text("TEST NOTIFICATIONS BUTTON")
              ),
<br />
<br />

This adds a button to the homepage that instantly sends a notification to the phone.

<br />

## Dependencies
            cupertino_icons: ^1.0.8
            http: ^1.6.0
            url_launcher: ^6.3.2
            shared_preferences: ^2.5.3
            firebase_core: ^4.2.1
            firebase_messaging: ^16.0.4
            flutter_local_notifications: ^19.5.0
            timezone: ^0.10.1
<br />

## Recordings

<video src="https://github.com/user-attachments/assets/f9cf8a23-1769-41d1-9428-e67bab77f940" controls muted>
  Couldn't play video
</video>

<video src="https://github.com/user-attachments/assets/38e72a5c-5582-4d88-909f-7943442ecb13" controls muted>
  Couldn't play video
</video>

## Images of the app

<img width="540" height="1200" alt="Screenshot_20251210_153350" src="https://github.com/user-attachments/assets/b25abee6-8cf4-473e-8c84-0908244b48c5" />

<img width="540" height="1200" alt="Screenshot_20251210_143601" src="https://github.com/user-attachments/assets/21a584e7-3d5a-47dc-86fc-8e175e3b769c" />

<img width="540" height="1200" alt="Screenshot_20251210_143545" src="https://github.com/user-attachments/assets/4b4d8fe9-7b3d-40d9-be1b-afa19148b690" />

<img width="540" height="1200" alt="Screenshot_20251210_143740" src="https://github.com/user-attachments/assets/ccd6cff3-91e2-4fb1-b83a-d7a4f4b7ce9e" />
