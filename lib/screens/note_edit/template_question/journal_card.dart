import 'package:flutter/material.dart';
import 'package:mood_journal/models/promt_template.dart';
import 'package:mood_journal/screens/note_edit/template_question/promt_preview_sheet.dart';

class JournalCard extends StatelessWidget {
  final PromptTemplate prompt;
  const JournalCard({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 170,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: prompt.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prompt.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    prompt.preview,
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, prompt.contents.join('\n\n'));
                        },
                        child: const Text('Add'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        // color: Theme.of(context).primaryColor,
                        onPressed: () {
                          showPromptPreview(context, prompt);
                        },
                        style: ButtonStyle(
                          // fixedSize: WidgetStatePropertyAll(Size(50, 30)),
                          // backgroundColor: MaterialStatePropertyAll(Colors.red),
                          shape: WidgetStatePropertyAll(CircleBorder()),
                        ),
                        child: Icon(Icons.crisis_alert_sharp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Image.asset(
              prompt.backgroundImage,
              width: 120,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  void showPromptPreview(BuildContext context, PromptTemplate prompt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) => PromptPreviewSheet(prompt: prompt),
    );
  }
}
