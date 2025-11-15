import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scroll_aware_appbar/src/bordered_bottom.dart';

class ScrollAwareScaffold extends StatefulWidget {
  /// The widget to display in the AppBar title area
  final Widget? appBarTitle;

  /// The widget to display as the page body (will be wrapped in scrollable)
  final Widget body;

  /// Leading widget in the AppBar (typically a back button or menu icon)
  final Widget? appBarLeading;

  /// Actions to display at the end of the AppBar
  final List<Widget>? appBarActions;

  /// Background color of the AppBar
  final Color? appBarBackgroundColor;

  /// Color of the bottom border when scrolled
  final Color? appBarBorderColor;

  /// Thickness of the bottom border in logical pixels
  final double appBarBorderThickness;

  /// Whether to center the title
  final bool appBarCenterTitle;

  /// Elevation of the AppBar
  final double appBarElevation;

  /// AppBar bottom widget (e.g., TabBar)
  final PreferredSizeWidget? appBarBottom;

  /// Scroll offset threshold to trigger border appearance (in pixels)
  final double scrollThreshold;

  /// Animation duration for border appearance/disappearance
  final Duration animationDuration;

  /// Text style for the title
  final TextStyle? appBarTitleTextStyle;

  /// Icon theme for AppBar icons
  final IconThemeData? appBarIconTheme;

  /// System overlay style for status bar
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Whether this app bar is being displayed at the top of the screen
  final bool primary;

  /// Whether to show the leading widget
  final bool automaticallyImplyLeading;

  /// Flexible space widget
  final Widget? appBarFlexibleSpace;

  /// Tool bar height
  final double? appBarToolbarHeight;

  // Extended Scaffold properties

  /// A bottom navigation bar to display at the bottom of the scaffold
  final Widget? bottomNavigationBar;

  /// The persistent bottom sheet to display
  final Widget? bottomSheet;

  /// Background color of the scaffold
  final Color? scaffoldBackgroundColor;

  /// A floating action button to display
  final Widget? floatingActionButton;

  /// Location of the floating action button
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Animator for the floating action button
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// A drawer to display on the left side
  final Widget? drawer;

  /// A drawer to display on the right side
  final Widget? endDrawer;

  /// Color of the drawer scrim
  final Color? drawerScrimColor;

  /// Width of the drawer
  final double? drawerEdgeDragWidth;

  /// Whether drawer can be opened by dragging
  final bool drawerEnableOpenDragGesture;

  /// Whether end drawer can be opened by dragging
  final bool endDrawerEnableOpenDragGesture;

  /// Whether to resize body to avoid bottom inset
  final bool? resizeToAvoidBottomInset;

  /// Whether body should extend behind AppBar
  final bool extendBody;

  /// Whether body should extend behind bottom navigation bar
  final bool extendBodyBehindAppBar;

  /// Callback when drawer is changed
  final DrawerCallback? onDrawerChanged;

  /// Callback when end drawer is changed
  final DrawerCallback? onEndDrawerChanged;

  /// Restoration ID for state restoration
  final String? restorationId;

  const ScrollAwareScaffold({
    Key? key,
    this.appBarTitle,
    required this.body,
    this.appBarLeading,
    this.appBarActions,
    this.appBarBackgroundColor,
    this.appBarBorderColor,
    this.appBarBorderThickness = 1.0,
    this.appBarCenterTitle = false,
    this.appBarElevation = 0.0,
    this.appBarBottom,
    this.scrollThreshold = 5.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.appBarTitleTextStyle,
    this.appBarIconTheme,
    this.systemOverlayStyle,
    this.primary = true,
    this.automaticallyImplyLeading = true,
    this.appBarFlexibleSpace,
    this.appBarToolbarHeight,
    // Scaffold properties
    this.bottomNavigationBar,
    this.bottomSheet,
    this.scaffoldBackgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.drawer,
    this.endDrawer,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.restorationId,
  }) : super(key: key);

  @override
  State<ScrollAwareScaffold> createState() => _ScrollAwareScaffoldState();
}

class _ScrollAwareScaffoldState extends State<ScrollAwareScaffold> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > widget.scrollThreshold;
    if (_isScrolled != isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }

  PreferredSizeWidget _buildBottomWidget() {
    final theme = Theme.of(context);
    final defaultBorderColor = widget.appBarBorderColor ??
        theme.dividerColor.withOpacity(0.2);

    if (widget.appBarBottom != null) {
      return BorderedBottom(
        bottom: widget.appBarBottom!,
        isScrolled: _isScrolled,
        borderColor: defaultBorderColor,
        borderThickness: widget.appBarBorderThickness,
        animationDuration: widget.animationDuration,
      );
    }

    return PreferredSize(
      preferredSize: Size.fromHeight(widget.appBarBorderThickness),
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
        height: widget.appBarBorderThickness,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _isScrolled ? defaultBorderColor : Colors.transparent,
              width: widget.appBarBorderThickness,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Scaffold properties
      backgroundColor: widget.scaffoldBackgroundColor,
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      drawerScrimColor: widget.drawerScrimColor,
      drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      onDrawerChanged: widget.onDrawerChanged,
      onEndDrawerChanged: widget.onEndDrawerChanged,
      restorationId: widget.restorationId,
      // AppBar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          (widget.appBarToolbarHeight ?? kToolbarHeight) +
              (widget.appBarBottom?.preferredSize.height ?? 0.0) +
              widget.appBarBorderThickness,
        ),
        child: AppBar(
          title: widget.appBarTitle,
          leading: widget.appBarLeading,
          actions: widget.appBarActions,
          backgroundColor:
          widget.appBarBackgroundColor ?? theme.scaffoldBackgroundColor,
          elevation: widget.appBarElevation,
          centerTitle: widget.appBarCenterTitle,
          systemOverlayStyle: widget.systemOverlayStyle,
          primary: widget.primary,
          automaticallyImplyLeading: widget.automaticallyImplyLeading,
          flexibleSpace: widget.appBarFlexibleSpace,
          titleTextStyle: widget.appBarTitleTextStyle,
          iconTheme: widget.appBarIconTheme,
          toolbarHeight: widget.appBarToolbarHeight,
          bottom: _buildBottomWidget(),
        ),
      ),
      body: ListView(
        controller: _scrollController,
        children: [widget.body],
      ),
    );
  }
}