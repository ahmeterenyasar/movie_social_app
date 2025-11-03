import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_text_styles.dart';
import '../../../data/models/user_model.dart';
import '../common/user_avatar.dart';

class PendingRequestItem extends StatefulWidget {
  final String friendshipId;
  final UserModel senderUser;
  final Function(String, String) onAccept;
  final Function(String) onReject;
  final Function(String) onUserTap;

  const PendingRequestItem({
    super.key,
    required this.friendshipId,
    required this.senderUser,
    required this.onAccept,
    required this.onReject,
    required this.onUserTap,
  });

  @override
  State<PendingRequestItem> createState() => _PendingRequestItemState();
}

class _PendingRequestItemState extends State<PendingRequestItem> {
  bool _isProcessing = false;

  Future<void> _handleAccept() async {
    setState(() => _isProcessing = true);
    await widget.onAccept(widget.friendshipId, widget.senderUser.id);
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleReject() async {
    setState(() => _isProcessing = true);
    await widget.onReject(widget.friendshipId);
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
        leading: UserAvatar(
          name: widget.senderUser.fullName,
          size: AppConstants.avatarSizeMedium,
        ),
        title: Text(
          widget.senderUser.fullName,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '@${widget.senderUser.nickname}',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent),
            ),
            const SizedBox(height: 4),
            Text(
              'Arkadaşlık isteği gönderdi',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            if (!_isProcessing) _buildActionButtons(),
            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        ),
        onTap: () => widget.onUserTap(widget.senderUser.id),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _handleAccept,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Kabul Et'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.paddingSmall,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.paddingSmall),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _handleReject,
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Reddet'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.paddingSmall,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
