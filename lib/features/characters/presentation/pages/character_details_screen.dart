import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_series/core/utils/colors.dart';
import 'package:rick_and_morty_series/features/characters/data/models/character_model.dart';

class CharacterDetailsScreen extends StatefulWidget {
  final CharacterModel character;

  const CharacterDetailsScreen({super.key, required this.character});

  @override
  State<CharacterDetailsScreen> createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen> with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _fadeCtrl;

  late Animation<double> _pulseAnim;
  late Animation<double> _scanAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // Episodes
  List<_EpisodeMeta> _episodes = [];
  bool _episodesLoading = true;
  bool _showAllEpisodes = false;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);

    _scanCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();

    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward();

    _pulseAnim = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _scanAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _scanCtrl, curve: Curves.linear));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));

    _fetchEpisodes();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _scanCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Episode Fetching ──────────────────────────────────────────────────────
  Future<void> _fetchEpisodes() async {
    final urls = widget.character.episode; // List<String>
    if (urls.isEmpty) {
      if (mounted) setState(() => _episodesLoading = false);
      return;
    }

    final results = await Future.wait(
      urls.map((url) async {
        try {
          final response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            final json = jsonDecode(response.body) as Map<String, dynamic>;
            return _EpisodeMeta(url: url, episode: json['episode'] as String? ?? '', name: json['name'] as String? ?? 'Unknown', airDate: json['air_date'] as String? ?? '');
          }
        } catch (_) {}
        // Fallback: parse from URL only
        return _EpisodeMeta(url: url, episode: 'EP ${_episodeNumber(url)}', name: 'Episode ${_episodeNumber(url)}', airDate: '');
      }),
    );

    if (mounted) {
      setState(() {
        _episodes = results.whereType<_EpisodeMeta>().toList();
        _episodesLoading = false;
      });
    }
  }

  String _episodeNumber(String url) => url.split('/').where((s) => s.isNotEmpty).last;

  Color get _statusColor {
    switch (widget.character.status.toLowerCase()) {
      case 'alive':
        return AppColors.primaryGreen;
      case 'dead':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  String get _statusLabel => widget.character.status.toUpperCase();

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHero(),
              FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildInfoGrid(), const SizedBox(height: 24), _buildLocationSection(), const SizedBox(height: 24), _buildOriginSection(), const SizedBox(height: 24), _buildEpisodesSection()]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.6),
              border: const Border(bottom: BorderSide(color: Color(0x2200FF41), width: 1)),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primaryGreen, size: 20),
                    ),
                    Expanded(
                      child: Text(
                        widget.character.name,
                        style: TextStyle(color: AppColors.primaryGreen.withOpacity(0.9), fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 0.5, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    // ID badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
                      ),
                      child: Text(
                        '#${widget.character.id}',
                        style: const TextStyle(color: AppColors.primaryGreen, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.5),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────
  Widget _buildHero() {
    return SizedBox(
      height: 420,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Character image
          Image.network(
            widget.character.image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.cardColor,
              child: const Icon(Icons.person, size: 80, color: AppColors.primaryGreen),
            ),
          ),

          // Dark gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.0, 0.6], colors: [Color(0xFF02040A), Colors.transparent]),
            ),
          ),

          // Animated scan line
          AnimatedBuilder(
            animation: _scanAnim,
            builder: (_, __) {
              const lineH = 90.0;
              return Positioned(
                left: 0,
                top: (420 + lineH) * _scanAnim.value - lineH,
                child: Container(
                  width: 2,
                  height: lineH,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, AppColors.primaryGreen.withOpacity(0.8), Colors.transparent]),
                  ),
                ),
              );
            },
          ),

          // Corner scanner brackets
          ..._buildCornerBrackets(),

          // Info at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dimension tag
                  if (widget.character.origin.name.isNotEmpty)
                    Text(
                      widget.character.origin.name.toUpperCase(),
                      style: TextStyle(color: AppColors.primaryGreen.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 2),
                    ),
                  const SizedBox(height: 4),
                  // Name
                  Text(
                    widget.character.name,
                    style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.1),
                  ),
                  const SizedBox(height: 10),
                  // Status + species chips
                  Row(
                    children: [
                      _StatusBadge(label: _statusLabel, color: _statusColor, pulseAnim: _pulseAnim),
                      const SizedBox(width: 8),
                      _Chip(label: widget.character.species),
                      if (widget.character.type.isNotEmpty) ...[const SizedBox(width: 8), _Chip(label: widget.character.type)],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCornerBrackets() {
    const size = 20.0;
    const thickness = 2.0;
    final color = AppColors.primaryGreen.withOpacity(0.5);

    Widget bracket({required Alignment alignment, required BorderRadius radius, required Border border}) {
      return Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(borderRadius: radius, border: border),
          ),
        ),
      );
    }

    return [
      bracket(
        alignment: Alignment.topLeft,
        radius: const BorderRadius.only(topLeft: Radius.circular(4)),
        border: Border(
          top: BorderSide(color: color, width: thickness),
          left: BorderSide(color: color, width: thickness),
        ),
      ),
      bracket(
        alignment: Alignment.topRight,
        radius: const BorderRadius.only(topRight: Radius.circular(4)),
        border: Border(
          top: BorderSide(color: color, width: thickness),
          right: BorderSide(color: color, width: thickness),
        ),
      ),
      bracket(
        alignment: Alignment.bottomLeft,
        radius: const BorderRadius.only(bottomLeft: Radius.circular(4)),
        border: Border(
          bottom: BorderSide(color: color, width: thickness),
          left: BorderSide(color: color, width: thickness),
        ),
      ),
      bracket(
        alignment: Alignment.bottomRight,
        radius: const BorderRadius.only(bottomRight: Radius.circular(4)),
        border: Border(
          bottom: BorderSide(color: color, width: thickness),
          right: BorderSide(color: color, width: thickness),
        ),
      ),
    ];
  }

  // ── Info Grid ─────────────────────────────────────────────────────────────
  Widget _buildInfoGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('SCAN RESULTS'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _InfoCard(label: 'SPECIES', value: widget.character.species, icon: Icons.science_outlined),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoCard(
                label: 'GENDER',
                value: widget.character.gender,
                icon: widget.character.gender.toLowerCase() == 'male'
                    ? Icons.male
                    : widget.character.gender.toLowerCase() == 'female'
                    ? Icons.female
                    : Icons.transgender,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _InfoCard(label: 'STATUS', value: widget.character.status, icon: Icons.favorite_border, accentColor: _statusColor, fullWidth: true),
      ],
    );
  }

  // ── Location Section ──────────────────────────────────────────────────────
  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('LAST KNOWN LOCATION'),
        const SizedBox(height: 12),
        _GlassCard(
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
                ),
                child: const Icon(Icons.location_on_outlined, color: AppColors.primaryGreen, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.character.location.name,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text('Current location', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, letterSpacing: 0.5)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.primaryGreen.withOpacity(0.5)),
            ],
          ),
        ),
      ],
    );
  }

  // ── Origin Section ────────────────────────────────────────────────────────
  Widget _buildOriginSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('ORIGIN DIMENSION'),
        const SizedBox(height: 12),
        _GlassCard(
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: AppColors.primaryGreen.withOpacity(0.2), blurRadius: 12)],
                ),
                child: const Icon(Icons.public, color: AppColors.primaryGreen, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.character.origin.name,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text('Origin universe', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, letterSpacing: 0.5)),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (_, __) => Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryGreen.withOpacity(_pulseAnim.value),
                    boxShadow: [BoxShadow(color: AppColors.primaryGreen.withOpacity(_pulseAnim.value * 0.5), blurRadius: 6)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Episodes Section ──────────────────────────────────────────────────────
  Widget _buildEpisodesSection() {
    final total = widget.character.episode.length;
    if (total == 0) return const SizedBox();

    const previewCount = 3;
    final visibleEpisodes = _showAllEpisodes ? _episodes : _episodes.take(previewCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionLabel('APPEARS IN'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
              ),
              child: Text(
                '$total EP',
                style: const TextStyle(color: AppColors.primaryGreen, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Loading state
        if (_episodesLoading)
          _GlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryGreen.withOpacity(0.7))),
                const SizedBox(width: 12),
                Text('SCANNING EPISODES...', style: TextStyle(color: AppColors.primaryGreen.withOpacity(0.6), fontSize: 11, letterSpacing: 2)),
              ],
            ),
          )
        else ...[
          // Episode cards
          ...visibleEpisodes.map(
            (ep) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _EpisodeCard(episode: ep),
            ),
          ),

          // View all / collapse toggle
          if (total > previewCount)
            GestureDetector(
              onTap: () => setState(() => _showAllEpisodes = !_showAllEpisodes),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _showAllEpisodes ? 'SHOW LESS' : 'VIEW ALL ${total - previewCount} MORE',
                      style: const TextStyle(color: AppColors.primaryGreen, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.5),
                    ),
                    const SizedBox(width: 6),
                    Icon(_showAllEpisodes ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.primaryGreen, size: 16),
                  ],
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: TextStyle(color: AppColors.primaryGreen.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 2.5),
  );
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.55),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primaryGreen.withOpacity(0.18), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? accentColor;
  final bool fullWidth;

  const _InfoCard({required this.label, required this.value, required this.icon, this.accentColor, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primaryGreen;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.55),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primaryGreen.withOpacity(0.18), width: 1),
          ),
          child: fullWidth
              ? Row(
                  children: [
                    // Left accent bar
                    Container(
                      width: 3,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6)],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, letterSpacing: 2)),
                        const SizedBox(height: 4),
                        Text(
                          value,
                          style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(icon, color: color.withOpacity(0.3), size: 32),
                  ],
                )
              : Stack(
                  children: [
                    // Left scan accent line
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, color.withOpacity(0.6), Colors.transparent]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, letterSpacing: 2)),
                          const SizedBox(height: 4),
                          Text(
                            value,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                    Positioned(top: 0, right: 0, child: Icon(icon, size: 28, color: AppColors.primaryGreen.withOpacity(0.1))),
                  ],
                ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Animation<double> pulseAnim;

  const _StatusBadge({required this.label, required this.color, required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: pulseAnim,
            builder: (_, __) => Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(pulseAnim.value),
                boxShadow: [BoxShadow(color: color.withOpacity(pulseAnim.value * 0.5), blurRadius: 4)],
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.2),
      ),
    );
  }
}

// ─── Episode Model ────────────────────────────────────────────────────────────

class _EpisodeMeta {
  final String url;
  final String episode; // e.g. "S01E01"
  final String name;
  final String airDate;

  const _EpisodeMeta({required this.url, required this.episode, required this.name, required this.airDate});
}

// ─── Episode Card ─────────────────────────────────────────────────────────────

class _EpisodeCard extends StatefulWidget {
  final _EpisodeMeta episode;

  const _EpisodeCard({required this.episode});

  @override
  State<_EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<_EpisodeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: _pressed ? AppColors.primaryGreen.withOpacity(0.08) : AppColors.cardColor.withOpacity(0.55),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _pressed ? AppColors.primaryGreen.withOpacity(0.4) : AppColors.primaryGreen.withOpacity(0.15), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon box
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
                ),
                child: const Icon(Icons.movie_filter_outlined, color: AppColors.primaryGreen, size: 24),
              ),
              const SizedBox(width: 14),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.episode.episode.toUpperCase(),
                      style: TextStyle(color: AppColors.primaryGreen.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.8),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.episode.name,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.episode.airDate.isNotEmpty) ...[const SizedBox(height: 2), Text(widget.episode.airDate, style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 11))],
                  ],
                ),
              ),

              Icon(Icons.chevron_right, color: _pressed ? AppColors.primaryGreen : AppColors.primaryGreen.withOpacity(0.3), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
