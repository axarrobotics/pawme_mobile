import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class RobotSettingsScreen extends StatefulWidget {
  final Map<String, dynamic> robot;

  const RobotSettingsScreen({super.key, required this.robot});

  @override
  State<RobotSettingsScreen> createState() => _RobotSettingsScreenState();
}

class _RobotSettingsScreenState extends State<RobotSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoUpdateEnabled = true;
  double _volume = 0.7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Robot Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'General',
            [
              _buildSettingTile(
                'Robot Name',
                widget.robot['name'],
                Icons.edit,
                onTap: () => _showEditNameDialog(),
              ),
              _buildSettingTile(
                'MAC Address',
                widget.robot['macId'],
                Icons.fingerprint,
              ),
              _buildSettingTile(
                'Firmware Version',
                'v2.1.3',
                Icons.system_update,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Preferences',
            [
              _buildSwitchTile(
                'Notifications',
                'Receive alerts from this robot',
                _notificationsEnabled,
                (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              _buildSwitchTile(
                'Auto Update',
                'Automatically update firmware',
                _autoUpdateEnabled,
                (value) {
                  setState(() {
                    _autoUpdateEnabled = value;
                  });
                },
              ),
              _buildSliderTile(
                'Volume',
                'Adjust robot speaker volume',
                _volume,
                (value) {
                  setState(() {
                    _volume = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Network',
            [
              _buildSettingTile(
                'WiFi Network',
                'Home Network',
                Icons.wifi,
                onTap: () => _showChangeNetworkDialog(),
              ),
              _buildSettingTile(
                'Signal Strength',
                '${widget.robot['signal']}%',
                Icons.signal_cellular_alt,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Danger Zone',
            [
              _buildSettingTile(
                'Reset Robot',
                'Reset to factory settings',
                Icons.restart_alt,
                textColor: Colors.orange,
                onTap: () => _showResetDialog(),
              ),
              _buildSettingTile(
                'Remove Robot',
                'Remove from your account',
                Icons.delete_forever,
                textColor: Colors.red,
                onTap: () => _showRemoveDialog(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    IconData icon, {
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, color: AppColors.textSecondary)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(
        value ? Icons.notifications_active : Icons.notifications_off,
        color: AppColors.primary,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  Widget _buildSliderTile(
    String title,
    String subtitle,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return ListTile(
      leading: const Icon(Icons.volume_up, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          Slider(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog() {
    final controller = TextEditingController(text: widget.robot['name']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Robot Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Robot Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangeNetworkDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Network'),
        content: const Text('This will reconnect your robot to a different WiFi network.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Robot'),
        content: const Text(
          'This will reset your robot to factory settings. All custom configurations will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Robot'),
        content: const Text(
          'Are you sure you want to remove this robot from your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
