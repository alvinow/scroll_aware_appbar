import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scroll_aware_appbar/src/bordered_bottom.dart';

/// A Scaffold with a scroll-aware AppBar that displays a bottom border when content is scrolled.
///
/// This widget extends the standard Scaffold interface and automatically detects scroll
/// position to show/hide a bottom border on the AppBar, similar to Google's Material
/// Design patterns. The AppBar remains pinned and always visible.
///
/// The border appears when the user scrolls down and disappears when at the top,
/// providing a visual cue about the scroll position.
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

  /// Elevation of the AppBar
  final double elevation;

  /// Tool bar height
  final double toolbarHeight;

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
    this.elevation = 0.0,
    this.toolbarHeight = 56.0,
    required this.slivers,
  }) : super(key: key);

  @override
  State<ScrollAwareAppBarCustom> createState() =>
      _ScrollAwareAppBarCustomState();
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

  PreferredSizeWidget _buildBottomWidget() {
    final theme = Theme.of(context);
    final defaultBorderColor =
        widget.borderColor ?? theme.dividerColor.withOpacity(0.2);

    if (widget.bottom != null) {
      return BorderedBottom(
        bottom: widget.bottom!,
        isScrolled: _isScrolled,
        borderColor: defaultBorderColor,
        borderThickness: widget.borderThickness,
        animationDuration: widget.animationDuration,
      );
    }

    return PreferredSize(
      preferredSize: Size.fromHeight(widget.borderThickness),
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
        height: widget.borderThickness,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _isScrolled ? defaultBorderColor : Colors.transparent,
              width: widget.borderThickness,
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            title: widget.title,
            leading: widget.leading,
            actions: widget.actions,
            backgroundColor:
            widget.backgroundColor ?? theme.scaffoldBackgroundColor,
            elevation: widget.elevation,
            centerTitle: widget.centerTitle,
            pinned: true, // Always visible
            floating: false,
            snap: false,
            systemOverlayStyle: widget.systemOverlayStyle,
            primary: widget.primary,
            automaticallyImplyLeading: widget.automaticallyImplyLeading,
            flexibleSpace: widget.flexibleSpace,
            toolbarHeight: widget.toolbarHeight,
            bottom: _buildBottomWidget(),
            titleTextStyle: widget.titleTextStyle,
            iconTheme: widget.iconTheme,
          ),
          ...widget.slivers,
        ],
      ),
    );
  }
}