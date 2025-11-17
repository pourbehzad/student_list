import 'package:flutter/material.dart';
import 'package:student_list/models/user.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  const UserListItem({
    super.key,
    required this.user,
    required this.onTap,
    required this.onDismissed,
  });

  Color _getAvatarColor(String id) {
    final colors = [
      Colors.amber,
      Colors.blue,
      Colors.brown,
      Colors.cyan,
      Colors.green,
      Colors.indigo,
      Colors.orange,
      Colors.pink,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.yellow,
    ];

    final hash = id.hashCode;
    final index = hash % colors.length;
    return colors[index].shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(user.id),
      background: Container(
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_sweep, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Confirm Deletion'),
              content: Text('Are you sure you whant to delet ${user.name}?'),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop(false);
                }, child: Text('Cancel')),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red.shade400),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) => onDismissed(),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: _getAvatarColor(user.id),
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(
            user.courses.isNotEmpty ? user.courses[0] : '',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey,
            size: 16,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
