import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/network_provider.dart';

class NetworkBannerWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const NetworkBannerWrapper({super.key, required this.child});

  @override
  ConsumerState<NetworkBannerWrapper> createState() => _NetworkBannerWrapperState();
}

class _NetworkBannerWrapperState extends ConsumerState<NetworkBannerWrapper> {
  bool _showOnlineMessage = false;

  @override
  Widget build(BuildContext context) {
    final networkStatus = ref.watch(networkProvider);

    // Listen for changes from offline to online to show "Kembali Online" briefly
    ref.listen(networkProvider, (previous, next) {
      if (previous == NetworkStatus.offline && next == NetworkStatus.online) {
        setState(() => _showOnlineMessage = true);
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _showOnlineMessage = false);
        });
      }
    });

    final bool isOffline = networkStatus == NetworkStatus.offline;
    final bool showBanner = isOffline || _showOnlineMessage;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            top: showBanner ? 0 : -100, // Slide from top
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isOffline ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: isOffline ? const Color(0xFFF59E0B).withOpacity(0.3) : const Color(0xFF10B981).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isOffline ? Icons.wifi_off_rounded : Icons.wifi_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isOffline
                              ? 'Koneksi terputus. Nyalakan kembali internet Anda.'
                              : 'Koneksi kembali stabil!',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
