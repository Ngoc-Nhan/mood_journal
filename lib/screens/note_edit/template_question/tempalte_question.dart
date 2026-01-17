import 'package:flutter/material.dart';
import 'package:mood_journal/constants/promts/default_promts.dart';
import 'package:mood_journal/models/promt_template.dart';
import 'package:mood_journal/screens/note_edit/template_question/journal_card.dart';

class TemplateQuestionScreen extends StatelessWidget {
  const TemplateQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Template'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.builder(
        itemCount: defaultPrompts.length,
        itemBuilder: (context, index) {
          final prompt = defaultPrompts[index];

          return JournalCard(prompt: prompt);
        },
      ),

      // ListView.builder(
      //   padding: const EdgeInsets.all(16),
      //   itemCount: defaultPrompts.length,
      //   itemBuilder: (context, index) =>
      //       _buildCardItem(context, defaultPrompts[index]),
      // ),
    );
  }

  Widget _buildCardItem(BuildContext context, PromptTemplate template) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 8),
                  Text(template.contents.join('\n')),
                  SizedBox(height: 8),
                  TextButton(onPressed: () {}, child: Text('Add')),
                ],
              ),
            ),
            ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 70,

                margin: EdgeInsets.all(8),
                child: Image(
                  image: AssetImage('assets/images/bear.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
