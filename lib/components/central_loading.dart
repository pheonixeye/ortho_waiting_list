import 'package:flutter/material.dart';

class CentralLoading extends StatelessWidget {
  const CentralLoading({super.key, this.progressMessage});
  final String? progressMessage;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                blurRadius: 1,
                spreadRadius: 1,
                color: Colors.green.shade500,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              Text(
                progressMessage ?? 'جاري التجميل...',
                style: const TextStyle(
                  color: Colors.black87,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
