import 'package:flutter/material.dart';

class EstatisticaCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icon;
  final Color corIcone;

  const EstatisticaCard({
    Key? key,
    required this.titulo,
    required this.valor,
    required this.icon,
    required this.corIcone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: corIcone.withOpacity(0.1),
              child: Icon(icon, color: corIcone, size: 22),
            ),
            const SizedBox(width: 14), 
            
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 12, 
                      color: Colors.grey.shade600, 
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    valor,
                    style: const TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}