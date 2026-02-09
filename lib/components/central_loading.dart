import 'package:flutter/material.dart';

class CentralLoading extends StatelessWidget {
  const CentralLoading({super.key});

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
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text(
                'جاري التجميل...',
                style: TextStyle(
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
