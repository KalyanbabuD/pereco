import 'package:flutter/material.dart';
import '../app_colors.dart';

class PaginationControl extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationControl({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    int startPage = 1;
    int endPage = totalPages;
    
    if (totalPages > 5) {
      if (currentPage <= 3) {
        endPage = 5;
      } else if (currentPage >= totalPages - 2) {
        startPage = totalPages - 4;
      } else {
        startPage = currentPage - 2;
        endPage = currentPage + 2;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              text: 'Previous',
              isEnabled: currentPage > 1,
              onTap: () => onPageChanged(currentPage - 1),
              isFirst: true,
            ),
            for (int i = startPage; i <= endPage; i++)
              _buildPageNumber(
                page: i,
                isActive: i == currentPage,
                onTap: () => onPageChanged(i),
              ),
            _buildButton(
              text: 'Next',
              isEnabled: currentPage < totalPages,
              onTap: () => onPageChanged(currentPage + 1),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required bool isEnabled,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
            bottom: BorderSide(color: Colors.grey.shade300),
            left: BorderSide(color: Colors.grey.shade300),
            right: isLast ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
          ),
          borderRadius: BorderRadius.horizontal(
            left: isFirst ? const Radius.circular(6) : Radius.zero,
            right: isLast ? const Radius.circular(6) : Radius.zero,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isEnabled ? const Color(0xFF6B7280) : const Color(0xFFD1D5DB),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPageNumber({
    required int page,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isActive ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF99B3D) : Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
            bottom: BorderSide(color: Colors.grey.shade300),
            left: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Text(
          page.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.cardDarkBlue,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
