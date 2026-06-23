### প্রশ্ন ১: Hot Reload আর Hot Restart-এর পার্থক্য কী?

**Interview Tips:** Fast refrash and just ui update → Reload; deterministic clean state ui → Restart।


---


### প্রশ্ন ২: Widget কী?

**Interview Tips:** Widget = Text, Button, Image, Row, Column, সবই Widget।

---

### প্রশ্ন ৩: StatefulWidget-এর lifecycle কীভাবে কাজ করে?

StatefulWidget-এর Lifecycle হলো Widget তৈরি হওয়া থেকে ধ্বংস হওয়া পর্যন্ত যে ধাপগুলো ঘটে।

ক্রম:

createState() → State object তৈরি হয়
initState() → একবার কল হয়, initial setup করা হয়
didChangeDependencies() → dependency পরিবর্তন হলে কল হয়
build() → UI তৈরি হয়
setState() → state পরিবর্তন হলে আবার build() কল হয়
didUpdateWidget() → parent widget update হলে কল হয়
deactivate() → widget tree থেকে সাময়িকভাবে সরানো হলে কল হয়
dispose() → widget destroy হওয়ার আগে resources release করা হয়

এক লাইনের উত্তর:

StatefulWidget Lifecycle হলো createState → initState → build → setState/build → dispose পর্যন্ত Widget-এর জীবনচক্র।

Interview Tip:

initState() = Initialization
build() = UI Render
setState() = UI Update
dispose() = Cleanup

---

### প্রশ্ন ৪: `build()` মেথডের ভূমিকা কী?

Widget-এর UI স্ক্রিনে দেখাবে।

যখন:

Widget প্রথমবার তৈরি হয়
setState() কল হয়
Parent Widget rebuild হয়

তখন build() আবার কল হতে পারে।

---

### প্রশ্ন ৫: `setState` কীভাবে কাজ করে?

যখন setState() কল করা হয়:

State-এর মান পরিবর্তন হয়।
Flutter Widget-টিকে rebuild করার জন্য মার্ক করে।
build() মেথড আবার কল হয়।
নতুন UI স্ক্রিনে দেখানো হয়।

প্রশ্ন ৬: Keys কী এবং কেন দরকার?

সহজ উত্তর:

Key হলো Widget-এর একটি Unique Identity। Flutter এটি ব্যবহার করে বুঝতে পারে কোন Widget কোন State-এর সাথে সম্পর্কিত।

এক লাইনের ইন্টারভিউ উত্তর:

Keys help Flutter identify widgets uniquely and preserve the correct state when widgets are reordered or rebuilt.

উদাহরণ:

ListTile(
  key: ValueKey(item.id),
  title: Text(item.name),
)
প্রশ্ন ৭: InheritedWidget কী কাজ করে?

সহজ উত্তর:

InheritedWidget ব্যবহার করে Widget Tree-এর নিচের Widget-গুলোর মধ্যে Data Share করা যায়।

এক লাইনের ইন্টারভিউ উত্তর:

InheritedWidget provides efficient data sharing and state propagation down the widget tree.

উদাহরণ:

Theme
MediaQuery
Localizations

সবগুলো InheritedWidget-এর উপর ভিত্তি করে তৈরি।

প্রশ্ন ৮: const Widgets ব্যবহার কেন করবেন?

সহজ উত্তর:

const Widget ব্যবহার করলে Flutter অপ্রয়োজনীয় Widget পুনরায় তৈরি করে না, ফলে Performance ভালো হয়।

এক লাইনের ইন্টারভিউ উত্তর:

Const widgets improve performance by reducing unnecessary widget rebuilds.

উদাহরণ:

const Text("Hello Flutter")
প্রশ্ন ৯: Navigator 1.0 vs Navigator 2.0 পার্থক্য কী?
Navigator 1.0	Navigator 2.0
Simple	Advanced
push/pop ব্যবহার করে	Router API ব্যবহার করে
Mobile App-এর জন্য যথেষ্ট	Web, Deep Linking-এর জন্য ভালো

এক লাইনের ইন্টারভিউ উত্তর:

Navigator 1.0 is imperative, while Navigator 2.0 is declarative and better suited for web routing and deep linking.

প্রশ্ন ১০: Material vs Cupertino Widgets কখন ব্যবহার করবেন?

Material Widgets

Android Style UI
Google Material Design অনুসরণ করে

Cupertino Widgets

iOS Style UI
Apple Human Interface Guidelines অনুসরণ করে

এক লাইনের ইন্টারভিউ উত্তর:

Material widgets provide Android-style UI, while Cupertino widgets provide iOS-style UI.

উদাহরণ:

MaterialButton()
CupertinoButton()
খুব ছোট Interview Revision
Key → Widget-এর Unique Identity
InheritedWidget → Data Share করার উপায়
const Widget → Performance Improve করে
Navigator 1.0 → push/pop
Navigator 2.0 → Router API
Material → Android UI
Cupertino → iOS UI

প্রশ্ন ১১: BuildContext কী?

সহজ উত্তর:

BuildContext হলো Widget-এর Tree-তে অবস্থান (location) নির্দেশ করার একটি reference।

এটি ব্যবহার করে Theme, Navigator, MediaQuery ইত্যাদি অ্যাক্সেস করা হয়।

এক লাইনের ইন্টারভিউ উত্তর:

BuildContext represents a widget's location in the widget tree.

উদাহরণ:

Navigator.of(context).push(...);
Theme.of(context);
প্রশ্ন ১২: MediaQuery এবং LayoutBuilder-এর পার্থক্য কী?

MediaQuery

Screen Size জানায়
Device Information দেয়

LayoutBuilder

Parent Widget-এর Available Space জানায়
Responsive Layout তৈরিতে সাহায্য করে

এক লাইনের ইন্টারভিউ উত্তর:

MediaQuery provides device information, while LayoutBuilder provides parent layout constraints.

প্রশ্ন ১৩: GlobalKey কবে ব্যবহার করবেন?

সহজ উত্তর:

GlobalKey ব্যবহার করা হয় কোনো Widget-এর State-কে অন্য জায়গা থেকে Access করার জন্য।

সবচেয়ে সাধারণ ব্যবহার:

GlobalKey<FormState> formKey = GlobalKey<FormState>();

এক লাইনের ইন্টারভিউ উত্তর:

GlobalKey provides unique access to a widget and its state across the widget tree.

প্রশ্ন ১৪: initState() vs didChangeDependencies()?
initState()	didChangeDependencies()
একবার কল হয়	একাধিকবার কল হতে পারে
Initial Setup	Dependency Update Handle
Controller তৈরি	Theme, Provider, MediaQuery ব্যবহার

এক লাইনের ইন্টারভিউ উত্তর:

Use initState for one-time initialization and didChangeDependencies for context-dependent initialization.

প্রশ্ন ১৫: dispose()-এ কী ক্লিনআপ করবেন?

সহজ উত্তর:

Widget Destroy হওয়ার আগে ব্যবহৃত Resources Release করতে dispose() ব্যবহার করা হয়।

যেগুলো Dispose করতে হয়:

TextEditingController
ScrollController
AnimationController
FocusNode
Timer
StreamSubscription

উদাহরণ:

@override
void dispose() {
  controller.dispose();
  super.dispose();
}

এক লাইনের ইন্টারভিউ উত্তর:

dispose() is used to release resources and prevent memory leaks when a widget is removed.

দ্রুত Revision
BuildContext → Widget-এর Location
MediaQuery → Device Info
LayoutBuilder → Parent Constraints
GlobalKey → Widget State Access
initState() → One-time Initialization
didChangeDependencies() → Context-based Initialization
dispose() → Resource Cleanup and Memory Leak Prevention

প্রশ্ন ১৬: const constructor কিভাবে কাজ করে?

সহজ উত্তর:

const constructor compile-time এ Object তৈরি করে এবং একই Object বারবার reuse করতে সাহায্য করে।

এক লাইনের ইন্টারভিউ উত্তর:

A const constructor creates compile-time constant objects that can be reused for better performance.

উদাহরণ:

class Label {
  final String text;

  const Label(this.text);
}
প্রশ্ন ১৭: final vs const পার্থক্য?
final	const
Runtime এ value পায়	Compile-time এ value পায়
একবার assign করা যায়	সম্পূর্ণ constant
API/Data এর জন্য বেশি ব্যবহার হয়	Fixed values এর জন্য ব্যবহার হয়

উদাহরণ:

final time = DateTime.now();
const pi = 3.1416;

এক লাইনের ইন্টারভিউ উত্তর:

final is assigned once at runtime, while const is a compile-time constant.

প্রশ্ন ১৮: main() এ runApp() কেন দরকার?

সহজ উত্তর:

runApp() Flutter Application শুরু করে এবং Root Widget কে Screen-এ Render করে।

উদাহরণ:

void main() {
  runApp(MyApp());
}

এক লাইনের ইন্টারভিউ উত্তর:

runApp() starts the Flutter application and attaches the root widget to the screen.

প্রশ্ন ১৯: Scaffold কী করে?

সহজ উত্তর:

Scaffold একটি Material Design Screen Structure প্রদান করে।

এটি দিয়ে সহজে:

AppBar
Body
Drawer
FloatingActionButton
BottomNavigationBar
SnackBar

ব্যবহার করা যায়।

উদাহরণ:

Scaffold(
  appBar: AppBar(
    title: Text("Home"),
  ),
  body: Center(
    child: Text("Hello"),
  ),
)

এক লাইনের ইন্টারভিউ উত্তর:

Scaffold provides the basic Material Design layout structure for a screen.

প্রশ্ন ২০: ThemeData দিয়ে গ্লোবাল থিম কিভাবে সেট করবেন?

সহজ উত্তর:

ThemeData ব্যবহার করে পুরো App-এর Color, Font এবং Style এক জায়গা থেকে নিয়ন্ত্রণ করা যায়।

উদাহরণ:

MaterialApp(
  theme: ThemeData(
    primarySwatch: Colors.blue,
  ),
)

Dark Theme:

MaterialApp(
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  themeMode: ThemeMode.system,
)

এক লাইনের ইন্টারভিউ উত্তর:

ThemeData is used to define and manage the application's global visual appearance.

দ্রুত Revision
const constructor → Compile-time Object Creation
final → Runtime Constant
const → Compile-time Constant
runApp() → App Start করে
Scaffold → Screen Layout Structure
ThemeData → Global App Theme Management

প্রশ্ন ২১: StatelessWidget কবে যথেষ্ট?

সহজ উত্তর:

যখন Widget-এর নিজের কোনো State থাকে না এবং UI শুধু Input Data-এর উপর নির্ভর করে, তখন StatelessWidget ব্যবহার করা হয়।

উদাহরণ:

Text
Logo
Static Button

এক লাইনের ইন্টারভিউ উত্তর:

Use StatelessWidget when the UI does not need to change after it is built.

প্রশ্ন ২২: StatefulWidget-এ Expensive Operation কোথায় রাখবেন?

সহজ উত্তর:

One-time Setup → initState()
Context-dependent Setup → didChangeDependencies()
build()-এ Heavy Task করা উচিত নয়

উদাহরণ:

API Initialization
Database Connection
Animation Controller Setup

এক লাইনের ইন্টারভিউ উত্তর:

Expensive operations should be performed in initState or outside build to avoid unnecessary work during rebuilds.

প্রশ্ন ২৩: ListView vs Column + SingleChildScrollView
ListView	Column + SingleChildScrollView
Large Data	Small Data
Lazy Loading	All Widgets একসাথে তৈরি
Better Performance	Simple Layout

এক লাইনের ইন্টারভিউ উত্তর:

ListView is preferred for large or dynamic lists, while SingleChildScrollView with Column is suitable for small static content.

প্রশ্ন ২৪: FutureBuilder কী কাজে লাগে?

সহজ উত্তর:

FutureBuilder Async Operation-এর Result UI-তে দেখানোর জন্য ব্যবহার করা হয়।

যেমন:

API Call
Database Query
File Read

উদাহরণ:

FutureBuilder(
  future: fetchData(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text(snapshot.data.toString());
    }
    return CircularProgressIndicator();
  },
)

এক লাইনের ইন্টারভিউ উত্তর:

FutureBuilder builds widgets based on the state of a Future.

প্রশ্ন ২৫: StreamBuilder কবে ব্যবহার করবেন?

সহজ উত্তর:

যখন Data বারবার Update হয় বা Real-Time Data আসে, তখন StreamBuilder ব্যবহার করা হয়।

উদাহরণ:

Firestore
WebSocket
Chat App
Live Location

উদাহরণ কোড:

StreamBuilder(
  stream: messageStream,
  builder: (context, snapshot) {
    return Text(snapshot.data.toString());
  },
)

এক লাইনের ইন্টারভিউ উত্তর:

StreamBuilder listens to a stream and rebuilds the UI whenever new data arrives.

দ্রুত Revision
StatelessWidget → No State
StatefulWidget → Has State
initState() → One-time Setup
ListView → Large Lists
SingleChildScrollView → Small Content
FutureBuilder → One-time Async Data
StreamBuilder → Real-Time Data Updates

প্রশ্ন ২৬: SafeArea কেন ব্যবহার করবেন?

সহজ উত্তর:

SafeArea Widget কনটেন্টকে Notch, Status Bar এবং Navigation Bar থেকে দূরে রাখে।

উদাহরণ:

SafeArea(
  child: Text("Hello Flutter"),
)

এক লাইনের ইন্টারভিউ উত্তর:

SafeArea ensures that content is displayed within the visible and safe area of the screen.

প্রশ্ন ২৭: Expanded আর Flexible পার্থক্য কী?
Expanded	Flexible
Available Space পুরো নেয়	প্রয়োজন অনুযায়ী Space নেয়
Tight Constraint	Loose Constraint
বেশি ব্যবহৃত	বেশি Control দেয়

উদাহরণ:

Row(
  children: [
    Expanded(child: Text("A")),
    Expanded(child: Text("B")),
  ],
)

এক লাইনের ইন্টারভিউ উত্তর:

Expanded forces a widget to fill available space, while Flexible allows it to use only the space it needs.

প্রশ্ন ২৮: SizedBox vs Container

SizedBox

Width/Height দেওয়ার জন্য
Empty Space তৈরির জন্য

Container

Padding
Margin
Decoration
Color
Alignment

উদাহরণ:

SizedBox(height: 20)
Container(
  color: Colors.blue,
  padding: EdgeInsets.all(10),
)

এক লাইনের ইন্টারভিউ উত্তর:

Use SizedBox for spacing and sizing, and Container when styling or decoration is needed.

প্রশ্ন ২৯: GestureDetector আর InkWell পার্থক্য?

GestureDetector

Gesture Detect করে
Ripple Effect নেই

InkWell

Gesture Detect করে
Material Ripple Effect দেয়

উদাহরণ:

GestureDetector(
  onTap: () {},
  child: Text("Tap"),
)
InkWell(
  onTap: () {},
  child: Text("Tap"),
)

এক লাইনের ইন্টারভিউ উত্তর:

GestureDetector handles gestures only, while InkWell provides Material touch feedback with ripple effects.

প্রশ্ন ৩০: ClipRRect / ClipPath কেন সাবধানে ব্যবহার করবেন?

সহজ উত্তর:

ClipRRect এবং ClipPath UI Clip করতে ব্যবহার হয়, কিন্তু বেশি ব্যবহার করলে Performance কমতে পারে।

ClipRRect উদাহরণ:

ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.asset("image.png"),
)

এক লাইনের ইন্টারভিউ উত্তর:

Clipping widgets should be used carefully because excessive clipping can affect rendering performance.

দ্রুত Revision
SafeArea → Notch ও Status Bar থেকে Content রক্ষা করে
Expanded → Available Space পূরণ করে
Flexible → প্রয়োজনমতো Space নেয়
SizedBox → Size/Spacing
Container → Styling/Decoration
GestureDetector → Gesture Detection
InkWell → Gesture + Ripple Effect
ClipRRect → Rounded Corners
ClipPath → Custom Shape Clipping
Excessive Clipping → Performance কমাতে পারে
প্রশ্ন ৩১: ListView.builder-এ itemCount না দিলে কী হয়?

সহজ উত্তর:

itemCount না দিলে Flutter জানে না কতগুলো Item তৈরি করতে হবে, ফলে অপ্রয়োজনীয় Item তৈরি হতে পারে।

উদাহরণ:

ListView.builder(
  itemCount: users.length,
  itemBuilder: (context, index) {
    return Text(users[index]);
  },
)

এক লাইনের ইন্টারভিউ উত্তর:

itemCount tells ListView.builder how many items to build and improves performance.

প্রশ্ন ৩২: ListTile কাস্টমাইজ কিভাবে করবেন?

সহজ উত্তর:

ListTile-এর বিভিন্ন অংশ কাস্টমাইজ করা যায়:

leading → বাম পাশে Widget
title → প্রধান টেক্সট
subtitle → নিচের টেক্সট
trailing → ডান পাশে Widget
onTap → Click Action

উদাহরণ:

ListTile(
  leading: Icon(Icons.person),
  title: Text("Fuad"),
  subtitle: Text("Flutter Developer"),
  trailing: Icon(Icons.arrow_forward),
)

এক লাইনের ইন্টারভিউ উত্তর:

ListTile can be customized using leading, title, subtitle, trailing, and interaction properties.

প্রশ্ন ৩৩: Image Loading Optimization কীভাবে করবেন?

সহজ উত্তর:

Flutter App-এ Image দ্রুত লোড করার জন্য:

Cached Image ব্যবহার করুন
Image Resize করুন
Placeholder দেখান
Preload করুন

উদাহরণ:

CachedNetworkImage(
  imageUrl: imageUrl,
)

এক লাইনের ইন্টারভিউ উত্তর:

Image optimization involves caching, resizing, and preloading images to improve performance and memory usage.

প্রশ্ন ৩৪: Future.delayed() কোথায় ব্যবহার করা হয়?

সহজ উত্তর:

নির্দিষ্ট সময় পরে কোনো কাজ চালানোর জন্য Future.delayed() ব্যবহার করা হয়।

উদাহরণ:

Future.delayed(
  Duration(seconds: 2),
  () {
    print("Done");
  },
);

ব্যবহার:

Splash Screen
Delayed Navigation
Debounce Logic

এক লাইনের ইন্টারভিউ উত্তর:

Future.delayed executes a task after a specified delay.

প্রশ্ন ৩৫: showDialog()-এ Context কোনটা দেবেন?

সহজ উত্তর:

সাধারণত বর্তমান Screen-এর Context ব্যবহার করা হয় যাতে Flutter সঠিক Navigator খুঁজে পায়।

উদাহরণ:

showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: Text("Hello"),
    );
  },
);

Dialog বন্ধ করতে:

Navigator.pop(context);

এক লাইনের ইন্টারভিউ উত্তর:

showDialog should use a valid screen-level context so Flutter can find the correct Navigator.

দ্রুত Revision
itemCount → List Size নির্ধারণ করে
ListTile → Ready-made List Item UI
Image Optimization → Cache, Resize, Preload
Future.delayed() → Delay-এর পর Task চালায়
showDialog() → Popup Dialog দেখায়
Navigator.pop() → Dialog বন্ধ করে

প্রশ্ন ৩৬: WillPopScope কী কাজে লাগে?

সহজ উত্তর:

WillPopScope Back Button বা Back Gesture নিয়ন্ত্রণ করতে ব্যবহার করা হয়।

উদাহরণ:

WillPopScope(
  onWillPop: () async {
    return false;
  },
  child: Scaffold(),
)

এখানে Back Button চাপলেও Screen বন্ধ হবে না।

এক লাইনের ইন্টারভিউ উত্তর:

WillPopScope intercepts back navigation and allows custom handling before a screen is popped.

প্রশ্ন ৩৭: OrientationBuilder vs MediaQuery.orientation
OrientationBuilder	MediaQuery
Orientation পরিবর্তনে Auto Rebuild হয়	Orientation তথ্য দেয়
Responsive UI-এর জন্য ভালো	Simple Check-এর জন্য ভালো

উদাহরণ:

OrientationBuilder(
  builder: (context, orientation) {
    return orientation == Orientation.portrait
        ? Text("Portrait")
        : Text("Landscape");
  },
)

এক লাইনের ইন্টারভিউ উত্তর:

OrientationBuilder rebuilds the UI on orientation changes, while MediaQuery simply provides orientation information.

প্রশ্ন ৩৮: Hero Animation কীভাবে কাজ করে?

সহজ উত্তর:

দুই Screen-এর একই Widget-এর মধ্যে Smooth Transition Animation তৈরি করতে Hero ব্যবহার করা হয়।

উদাহরণ:

Hero(
  tag: "profile",
  child: Image.asset("profile.png"),
)

দুই Screen-এ একই tag থাকলে Animation কাজ করবে।

এক লাইনের ইন্টারভিউ উত্তর:

Hero creates a shared element transition between two routes using matching tags.

প্রশ্ন ৩৯: AnimatedContainer কবে ব্যবহার করবেন?

সহজ উত্তর:

Container-এর Size, Color, Padding, BorderRadius ইত্যাদি Animate করতে AnimatedContainer ব্যবহার করা হয়।

উদাহরণ:

AnimatedContainer(
  duration: Duration(milliseconds: 500),
  width: isExpanded ? 200 : 100,
)

এক লাইনের ইন্টারভিউ উত্তর:

AnimatedContainer automatically animates changes to its properties over a specified duration.

প্রশ্ন ৪০: FPS বা Jank কিভাবে Troubleshoot করবেন?

সহজ উত্তর:

Flutter App যদি Lag করে বা Animation Smooth না হয়, তাহলে:

Flutter DevTools ব্যবহার করুন
Performance Overlay দেখুন
Profile Mode-এ Run করুন
Heavy Calculation build() থেকে সরান
Large Widget Tree Optimize করুন

Command:

flutter run --profile

এক লাইনের ইন্টারভিউ উত্তর:

FPS issues and jank can be diagnosed using Flutter DevTools, Performance Overlay, and Profile Mode.

দ্রুত Revision
WillPopScope → Back Button Control
OrientationBuilder → Orientation Change হলে Rebuild
MediaQuery → Orientation Info দেয়
Hero → Shared Element Animation
AnimatedContainer → Automatic Property Animation
FPS → Frames Per Second
Jank → UI Lag বা Stutter
DevTools → Performance Debugging Tool
Profile Mode → Real Performance Analysis Mode

প্রশ্ন ৪১: CustomPainter কী এবং কবে দরকার?

সহজ উত্তর:

CustomPainter ব্যবহার করে Canvas-এর উপর Custom Drawing করা যায়।

ব্যবহার:

Chart
Graph
Signature Pad
Custom Shape
Wave Animation

উদাহরণ:

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Drawing code
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

এক লাইনের ইন্টারভিউ উত্তর:

CustomPainter allows custom drawing directly on a canvas for complex graphics and visualizations.

প্রশ্ন ৪২: RepaintBoundary কেন গুরুত্বপূর্ণ?

সহজ উত্তর:

RepaintBoundary Widget-এর Repaint আলাদা করে Performance Improve করে।

যদি একটি Widget পরিবর্তন হয়, তাহলে পুরো Screen Repaint না হয়ে শুধু সেই অংশ Repaint হবে।

উদাহরণ:

RepaintBoundary(
  child: CustomPaint(
    painter: MyPainter(),
  ),
)

এক লাইনের ইন্টারভিউ উত্তর:

RepaintBoundary isolates repaint operations to improve rendering performance.

প্রশ্ন ৪৩: TickerProviderStateMixin কী?

সহজ উত্তর:

AnimationController-এর জন্য Vsync Provider হিসেবে কাজ করে।

উদাহরণ:

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }
}

এক লাইনের ইন্টারভিউ উত্তর:

TickerProviderStateMixin provides a ticker for efficient animation synchronization with the screen refresh rate.

প্রশ্ন ৪৪: FocusNode এবং Keyboard Management কিভাবে করবেন?

সহজ উত্তর:

FocusNode ব্যবহার করে TextField-এর Focus নিয়ন্ত্রণ করা হয়।

উদাহরণ:

FocusNode emailFocus = FocusNode();

TextField(
  focusNode: emailFocus,
)

পরের Field-এ Focus পাঠাতে:

FocusScope.of(context).nextFocus();

Keyboard Hide করতে:

FocusScope.of(context).unfocus();

এক লাইনের ইন্টারভিউ উত্তর:

FocusNode is used to manage input focus and keyboard navigation between widgets.

প্রশ্ন ৪৫: Platform.isAndroid / Platform.isIOS কখন এড়াবেন?

সহজ উত্তর:

শুধু UI পরিবর্তনের জন্য Platform Check বেশি ব্যবহার করা উচিত নয়।

এতে Code Complex হয়ে যায়।

ভালো বিকল্প:

Theme.of(context).platform

অথবা

defaultTargetPlatform

কখন ব্যবহার করবেন?

Platform Channel
Native Plugin
Device Specific Feature

এক লাইনের ইন্টারভিউ উত্তর:

Avoid excessive use of Platform.isAndroid or Platform.isIOS for UI logic; prefer platform-aware widgets and themes when possible.

দ্রুত Revision
CustomPainter → Custom Drawing
Canvas → Drawing Surface
RepaintBoundary → Repaint Optimization
TickerProviderStateMixin → Animation Vsync Provider
SingleTickerProviderStateMixin → One Animation Controller
FocusNode → Input Focus Control
nextFocus() → Next Field Focus
unfocus() → Keyboard Hide
Platform.isAndroid → Platform Detection
defaultTargetPlatform → Recommended Platform Check

প্রশ্ন ৪৬: অ্যাসেট (ইমেজ/ফন্ট) যোগ করার নিয়ম?

সহজ উত্তর:

Flutter-এ Image বা Font ব্যবহার করতে হলে pubspec.yaml-এ Register করতে হয়।

উদাহরণ:

flutter:
  assets:
    - assets/images/

  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf

তারপর:

flutter pub get

এক লাইনের ইন্টারভিউ উত্তর:

Assets and fonts are registered in pubspec.yaml and loaded into the application using Flutter's asset system.

প্রশ্ন ৪৭: uses-material-design: true মানে কী?

সহজ উত্তর:

এটি Flutter-কে Material Design Icons এবং Material Resources ব্যবহার করতে দেয়।

উদাহরণ:

flutter:
  uses-material-design: true

এক লাইনের ইন্টারভিউ উত্তর:

uses-material-design enables Material Design resources, including Material Icons.

প্রশ্ন ৪৮: Debug vs Profile vs Release Mode
Debug	Profile	Release
Development	Performance Testing	Production
Hot Reload আছে	Performance Measure করা যায়	Fastest
Slow	Near Production Speed	Maximum Performance

এক লাইনের ইন্টারভিউ উত্তর:

Debug is for development, Profile is for performance analysis, and Release is for production deployment.

Command:

flutter run
flutter run --profile
flutter run --release
প্রশ্ন ৪৯: Internationalization (i18n) কী?

সহজ উত্তর:

একই App-কে একাধিক ভাষায় ব্যবহারযোগ্য করার প্রক্রিয়াকে Internationalization (i18n) বলে।

উদাহরণ:

English
বাংলা
Arabic

MaterialApp:

MaterialApp(
  supportedLocales: [
    Locale('en'),
    Locale('bn'),
  ],
)

এক লাইনের ইন্টারভিউ উত্তর:

Internationalization enables an application to support multiple languages and regions.

প্রশ্ন ৫০: Accessibility (a11y) Checklist কী?

সহজ উত্তর:

Accessibility নিশ্চিত করে যে প্রতিবন্ধী বা সহায়ক প্রযুক্তি ব্যবহারকারী মানুষও App ব্যবহার করতে পারে।

Checklist:

Meaningful Labels
Screen Reader Support
Proper Contrast
Large Tap Area
Correct Focus Order
Semantic Widgets ব্যবহার

উদাহরণ:

Image.asset(
  "logo.png",
  semanticLabel: "Company Logo",
)

এক লাইনের ইন্টারভিউ উত্তর:

Accessibility ensures that applications are usable by everyone, including users who rely on assistive technologies.

দ্রুত Revision (Flutter Interview Top 50 শেষ)
Assets → pubspec.yaml-এ Register করতে হয়
Fonts → pubspec.yaml-এ Configure করতে হয়
uses-material-design → Material Icons Enable করে
Debug Mode → Development
Profile Mode → Performance Testing
Release Mode → Production
i18n → Multi-language Support
a11y → Accessibility
Semantics → Screen Reader Support
TalkBack / VoiceOver → Accessibility Testing Tools