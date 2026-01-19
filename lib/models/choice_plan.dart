// import 'package:flutter/material.dart';
// import '../pages/plan.dart';
// import '../pages/journey.dart';
// import '../pages/talk_ai.dart';
// import '../pages/read.dart';

// class featureItem {
//   final IconData icon;
//   final Color iconBg;
//   final String title;
//   final Widget page;

//   featureItem({
//     required this.icon,
//     required this.iconBg,
//     required this.title,
//     required this.page,
//   });
// }

// final List<featureItem> features = [
//   featureItem(
//     icon: Icons.edit_note,
//     iconBg: Colors.pink.shade100,
//     title: 'Talk with AI',
//     page: TalkAi(),
//   ),
//   featureItem(
//     icon: Icons.park,
//     iconBg: Colors.green.shade200,
//     title: 'Plan',
//     page: Plan(),
//   ),
//   featureItem(
//     icon: Icons.menu_book,
//     iconBg: Colors.pink.shade100,
//     title: 'Read',
//     page: Read(),
//   ),
//   featureItem(
//     icon: Icons.edit_note,
//     iconBg: Colors.pink.shade100,
//     title: 'Journey',
//     page: Journey(),
//   ),
// ];

// class ChoiceOption extends StatefulWidget {
//   const ChoiceOption({super.key});

//   @override
//   State<ChoiceOption> createState() => _ChoiceOptionState();
// }

// class _ChoiceOptionState extends State<ChoiceOption> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 46),

//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: features.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, //  mỗi hàng 2 component
//           crossAxisSpacing: 20,
//           mainAxisSpacing: 16,
//           childAspectRatio: 1.5,
//         ),
//         itemBuilder: (context, index) {
//           final item = features[index];
//           return (GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => item.page),
//               );
//             },
//             child: Container(
//               // padding: const EdgeInsets.symmetric(vertical: 2),
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 235, 235, 235),
//                 borderRadius: BorderRadius.circular(24),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),

//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: item.iconBg,
//                       shape: BoxShape.rectangle,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(item.icon, size: 24),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(item.title),
//                 ],
//               ),
//             ),
//           ));
//         },
//       ),
//     );
//   }
// }
