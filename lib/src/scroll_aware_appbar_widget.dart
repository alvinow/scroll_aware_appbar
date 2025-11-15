// FILE: lib/src/scroll_aware_appbar_widget.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A scroll-aware AppBar that displays a bottom border when content is scrolled.
///
/// This widget automatically detects scroll position and shows/hides a bottom
/// border to indicate when content is scrolling beneath the AppBar, similar
/// to Google's Material Design patterns.
///
/// The border appears when the user scrolls down and disappears when at the top,
/// providing a visual cue about the scroll position.
///
/// Example:
/// ```dart
/// ScrollAwareAppBar(
///   title: Text('My App'),
///   body: ListView.builder(
///     itemCount: 50,
///     itemBuilder: (context, index) => ListTile(
///       title: Text('Item $index'),
///     ),
///   ),
/// )
/// ```
class ScrollAwareAppBar extends StatefulWidget {
  /// The widget to display in the AppBar title area
  final Widget? title;

  /// The widget to display as the page body
  final Widget body;

  /// Leading widget in the AppBar (typically a back button or menu icon)
  final Widget? leading;

  /// Actions to display at the end of the AppBar
  final List<Widget>? actions;

  /// Background color of the AppBar
  final Color? backgroundColor;

  /// Color of the bottom border when scrolled
  final Color? borderColor;

  /// Thickness of the bottom border in logical pixels
  final double borderThickness;

  /// Whether to center the title
  final bool centerTitle;

  /// Elevation of the AppBar when scrolled
  final double scrolledElevation;

  /// Elevation of the AppBar when at top
  final double elevation;

  /// AppBar bottom widget (e.g., TabBar)
  final PreferredSizeWidget? bottom;

  /// Scroll offset threshold to trigger border appearance (in pixels)
  final double scrollThreshold;

  /// Animation duration for border appearance/disappearance
  final Duration animationDuration;

  /// Text style for the title
  final TextStyle? titleTextStyle;

  /// Icon theme for AppBar icons
  final IconThemeData? iconTheme;

  /// System overlay style for status bar
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Whether this app bar is being displayed at the top of the screen
  final bool primary;

  /// Whether to show the leading widget
  final bool automaticallyImplyLeading;

  /// Flexible space widget
  final Widget? flexibleSpace;

  const ScrollAwareAppBar({
    Key? key,
    this.title,
    required this.body,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.borderColor,
    this.borderThickness = 1.0,
    this.centerTitle = false,
    this.scrolledElevation = 0.0,
    this.elevation = 0.0,
    this.bottom,
    this.scrollThreshold = 5.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.titleTextStyle,
    this.iconTheme,
    this.systemOverlayStyle,
    this.primary = true,
    this.automaticallyImplyLeading = true,
    this.flexibleSpace,
  }) : super(key: key);

  @override
  State<ScrollAwareAppBar> createState() => _ScrollAwareAppBarState();
}

class _ScrollAwareAppBarState extends State<ScrollAwareAppBar> {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderColor = widget.borderColor ??
        theme.dividerColor.withOpacity(0.2);

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: widget.title,
              leading: widget.leading,
              actions: widget.actions,
              backgroundColor: widget.backgroundColor ?? theme.scaffoldBackgroundColor,
              elevation: _isScrolled ? widget.scrolledElevation : widget.elevation,
              centerTitle: widget.centerTitle,
              floating: true,
              pinned: true,
              snap: false,
              systemOverlayStyle: widget.systemOverlayStyle,
              primary: widget.primary,
              automaticallyImplyLeading: widget.automaticallyImplyLeading,
              flexibleSpace: widget.flexibleSpace,
              bottom: widget.bottom != null
                  ? _BorderedBottom(
                      bottom: widget.bottom!,
                      isScrolled: _isScrolled,
                      borderColor: defaultBorderColor,
                      borderThickness: widget.borderThickness,
                      animationDuration: widget.animationDuration,
                    )
                  : PreferredSize(
                      preferredSize: const Size.fromHeight(0.0),
                      child: AnimatedContainer(
                        duration: widget.animationDuration,
                        curve: Curves.easeInOut,
                        height: widget.borderThickness,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _isScrolled
                                  ? defaultBorderColor
                                  : Colors.transparent,
                              width: widget.borderThickness,
                            ),
                          ),
                        ),
                      ),
                    ),
              titleTextStyle: widget.titleTextStyle,
              iconTheme: widget.iconTheme,
            ),
          ];
        },
        body: widget.body,
      ),
    );
  }
}

/// Wrapper for custom bottom widget with border
class _BorderedBottom extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  final bool isScrolled;
  final Color borderColor;
  final double borderThickness;
  final Duration animationDuration;

  const _BorderedBottom({
    required this.bottom,
    required this.isScrolled,
    required this.borderColor,
    required this.borderThickness,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        bottom,
        AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          height: borderThickness,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isScrolled ? borderColor : Colors.transparent,
                width: borderThickness,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    bottom.preferredSize.height + borderThickness,
  );
}

/// Alternative implementation using CustomScrollView for more flexibility.
///
/// This version is ideal when you need to use slivers directly or want
/// more control over the scrollable content.
///
/// Example:
/// ```dart
/// ScrollAwareAppBarCustom(
///   title: Text('Custom Scroll'),
///   slivers: [
///     SliverList(
///       delegate: SliverChildBuilderDelegate(
///         (context, index) => ListTile(title: Text('Item $index')),
///         childCount: 50,
///       ),
///     ),
///   ],
/// )
/// ```
class ScrollAwareAppBarCustom extends StatefulWidget {
  /// The widget to display in the AppBar title area
  final Widget? title;

  /// Leading widget in the AppBar
  final Widget? leading;

  /// Actions to display at the end of the AppBar
  final List<Widget>? actions;

  /// Background color of the AppBar
  final Color? backgroundColor;

  /// Color of the bottom border when scrolled
  final Color? borderColor;

  /// Thickness of the bottom border in logical pixels
  final double borderThickness;

  /// Whether to center the title
  final bool centerTitle;

  /// Scroll offset threshold to trigger border appearance (in pixels)
  final double scrollThreshold;

  /// Animation duration for border appearance/disappearance
  final Duration animationDuration;

  /// Text style for the title
  final TextStyle? titleTextStyle;

  /// Icon theme for AppBar icons
  final IconThemeData? iconTheme;

  /// AppBar bottom widget (e.g., TabBar)
  final PreferredSizeWidget? bottom;

  /// System overlay style for status bar
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Whether this app bar is being displayed at the top of the screen
  final bool primary;

  /// Whether to show the leading widget
  final bool automaticallyImplyLeading;

  /// Flexible space widget
  final Widget? flexibleSpace;

  /// List of slivers to display in the body
  final List<Widget> slivers;

  const ScrollAwareAppBarCustom({
    Key? key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.borderColor,
    this.borderThickness = 1.0,
    this.centerTitle = false,
    this.scrollThreshold = 5.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.titleTextStyle,
    this.iconTheme,
    this.bottom,
    this.systemOverlayStyle,
    this.primary = true,
    this.automaticallyImplyLeading = true,
    this.flexibleSpace,
    required this.slivers,
  }) : super(key: key);

  @override
  State<ScrollAwareAppBarCustom> createState() => _ScrollAwareAppBarCustomState();
}

class _ScrollAwareAppBarCustomState extends State<ScrollAwareAppBarCustom> {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderColor = widget.borderColor ??
        theme.dividerColor.withOpacity(0.2);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            title: widget.title,
            leading: widget.leading,
            actions: widget.actions,
            backgroundColor: widget.backgroundColor ?? theme.scaffoldBackgroundColor,
            elevation: 0,
            centerTitle: widget.centerTitle,
            floating: true,
            pinned: true,
            snap: false,
            systemOverlayStyle: widget.systemOverlayStyle,
            primary: widget.primary,
            automaticallyImplyLeading: widget.automaticallyImplyLeading,
            flexibleSpace: widget.flexibleSpace,
            bottom: widget.bottom != null
                ? _BorderedBottom(
                    bottom: widget.bottom!,
                    isScrolled: _isScrolled,
                    borderColor: defaultBorderColor,
                    borderThickness: widget.borderThickness,
                    animationDuration: widget.animationDuration,
                  )
                : PreferredSize(
                    preferredSize: const Size.fromHeight(0.0),
                    child: AnimatedContainer(
                      duration: widget.animationDuration,
                      curve: Curves.easeInOut,
                      height: widget.borderThickness,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _isScrolled
                                ? defaultBorderColor
                                : Colors.transparent,
                            width: widget.borderThickness,
                          ),
                        ),
                      ),
                    ),
                  ),
            titleTextStyle: widget.titleTextStyle,
            iconTheme: widget.iconTheme,
          ),
          ...widget.slivers,
        ],
      ),
    );
  }
}
