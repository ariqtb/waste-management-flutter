import 'package:flutter/material.dart';

exitModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Apakah anda ingin keluar?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Tidak')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    Navigator.pop(context, true);
                  },
                  child: Text('Ya')),
            ],
          ));
}
