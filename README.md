# sms_advanced
<a href="https://www.buymeacoffee.com/EddieGenius" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>

This is an SMS library for Flutter.

## Getting Started


### Installation and Usage

Once you're familiar with Flutter you may install this package adding `sms_advanced` (1.0.1 or higher) to the dependencies list of the `pubspec.yaml` file as follow:

```yaml
...
dependencies:
  flutter:
    sdk: flutter

  sms_advanced: ^1.0.1
...
```

Then run the command `flutter packages get` on the console.

## Querying SMS messages

Add the import statement for `sms_advanced` and create an instance of the *SmsQuery* class:

```dart
import 'package:sms_advanced/sms_advanced.dart';

void main() {
  SmsQuery query = new SmsQuery();
}

```

## Getting all SMS messages

```dart
List<SmsMessage> messages = await query.getAllSms;
``` 

**Note**: _the use of `await` keyword means that `getAllSms` is resolved asynchronously and a Future is retorned. To use await, you must be in a function marked `async`._

## Filtering SMS messages

The method `querySms` from the `SmsQuery` class returns a list of filtered SMS messages that match the supplied parameters. For example, for querying all the SMS messages sent and received, you could this code:

```dart
await query.querySms({
    kinds: [SmsQueryKind.Inbox, SmsQueryKind.Sent]
});
```

You can also query all the SMS messages sent and received from a specific contact:

```dart
await query.querySms({
    address: getContactAddress()
});
```

## Getting all Threads Conversations

With `SmsQuery` you can also get the entire list of conversations:

```dart
List<SmsThread> threads = await query.getAllThreads;
```
## extract information
```dart
List<SmsThread> threads = await query.getAllThreads;
  for( var index = num ; index >= threads.length; index-- ) { 
       String sendernumber = threads[index].contact?.address;
       String sim = threads[index].messages.first.sim.toString();
       String message = threads[index].messages.first.body;
       print('sender number: $sendernumber');
       print('reciever sim: $sim');
       print('message: $message');
   } 
```
## Getting the Contact info

Each conversation thread is related with a Contact. 
The class `Contact` contains all the info of a thread contact (address, photo, full name).
To get access to `Contact` class you must import `'package:sms_advanced/contact.dart'` into your dart file:

```dart
import 'package:sms_advanced/contact.dart';

void main() {
  ...
  Contact contact = threads.first.contact;
  print(contact.address);
}
```

## Querying Contact

You can also query a contact by its address _(phone number)_:

```dart
import 'package:sms_advanced/contact.dart';

void main() {
  ContactQuery contacts = new ContactQuery();
  Contact contact = await contacts.queryContact(someAddress());
  print(contact.fullName);
}
String getAddress() { return someRandomAddress; }
```

## The Contact photo

You can retrieve the photo of the contact (full size or thumbnail):

```dart
...
Uint8List fullSize = contact.photo.bytes;
Uint8List thumbnail = contact.thumbnail.bytes;
```

## User Profile

Some times it is useful to request basic info of the phone owner, like the contact photo, addresses, etc.

```dart
import 'package:sms_advanced/contact.dart';

UserProfileProvider provider = new UserProfileProvider();
UserProfile profile = await provider.getUserProfile();
print(profile.fullName);
```

## Sending SMS

What about sending a SMS? All you have to do is to create an instance of the `SmsSender` class:

```dart
import 'package:sms_advanced/sms_advanced.dart';

void main() {
  SmsSender sender = new SmsSender();
  String address = someAddress();
  ...
  sender.sendSms(new SmsMessage(address, 'Hello flutter world!'));
}
```

To be notified when the message is sent and/or delivered, you must add a listener to your message:

```dart
import 'package:sms_advanced/sms_advanced.dart';

void main() {
  SmsSender sender = new SmsSender();
  String address = someAddress();
  ...
  SmsMessage message = new SmsMessage(address, 'Hello flutter world!');
  message.onStateChanged.listen((state) {
    if (state == SmsMessageState.Sent) {
      print("SMS is sent!");
    } else if (state == SmsMessageState.Delivered) {
      print("SMS is delivered!");
    }
  });
  sender.sendSms(message);
}
```
Some times it is useful to be notified of delivered messages regardless of the message. To do that you must subscribe to the `onSmsDelivered` of the `SmsSender` class instance:

```dart
void main() {
...
SmsSender sender = new SmsSender();
sender.onSmsDelivered.listen((SmsMessage message){
  print('${message.address} received your message.');
}));
}
```

You can also send with another SimCard:

```dart
void main() {
SimCardsProvider provider = new SimCardsProvider();
SimCard card = await provider.getSimCards()[0];
SmsSender sender = new SmsSender();
SmsMessage message = new SmsMessage("address", "message");
sender.sendSMS(message, simCard: card);
}
```

**Note**: Using the `onSmsDelivered` from the `SmsSender` will only notify to listeners of messages that has been sent through `SmsSender.send()`.

## Receiving SMS

If you want to be notified for incoming new messages you must subscribe to an instance of the `SmsReceiver` class:

```dart
import 'package:sms_advanced/sms_advanced.dart';

void main() {
  SmsReceiver receiver = new SmsReceiver();
  receiver.onSmsReceived.listen((SmsMessage msg) => print(msg.body));
}
```

## Deleting SMS

Only deleting one by one is available. Don't forget to make your sms app the default sms app.
[blogpost guide](https://android-developers.googleblog.com/2013/10/getting-your-sms-apps-ready-for-kitkat.html)


```dart
import 'package:sms_advanced/sms_advanced.dart';

void main() {
SmsRemover smsRemover = SmsRemover();
<boolean value> = await smsRemover.removeSmsById(sms.id, _smsThread.threadId);
}
```

## Roadmap

|                                      | IOS     | Web     | Android |
|--------------------------------------|---------|---------|---------|
| SMS Sender                           | &check; | &check; | &check; |
| SMS Receiver                         |         |         | &check; |
| SMS Delivery                         |         |         | &check; |
| SMS Query                            |         |         | &check; |
| SMS Thread                           |         |         | &check; |
| Contact                              |         |         | &check; |
| Contact Photo (full size, thumbnail) |         |         | &check; |
| User profile (basic info)            |         |         | &check; |
| SMS Delete One-by-one                |         |         | &check; |


## Android Integration


### Activity Changes

Note that `sms_advanced` requires the use of a `FragmentActivity` instead of an
`Activity`. To update your application:

* If you are using `FlutterActivity` directly, change it to
`FlutterFragmentActivity` in your `AndroidManifest.xml`.
* If you are using a custom activity, update your `MainActivity.java`:

    ```java
    import io.flutter.embedding.android.FlutterFragmentActivity;

    public class MainActivity extends FlutterFragmentActivity {
        // ...
    }
    ```

    or MainActivity.kt:

    ```kotlin
    import io.flutter.embedding.android.FlutterFragmentActivity

    class MainActivity: FlutterFragmentActivity() {
        // ...
    }
    ```

    to inherit from `FlutterFragmentActivity`.




## Contributions

Any contribution is welcome.
