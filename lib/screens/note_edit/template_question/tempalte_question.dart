import 'package:flutter/material.dart';
import 'package:mood_journal/core/promts/default_promts.dart';
import 'package:mood_journal/models/promt_template.dart';

class TemplateQuestionScreen extends StatelessWidget {
  const TemplateQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Template'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: defaultPrompts.length,
          itemBuilder: (context, index) =>
              _buildCardItem(context, defaultPrompts[index]),
        ),
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, PromptTemplate template) {
    return Card(
      child: Container(
        color: Colors.grey[200],
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
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(template.contents.join('\n')),
                  SizedBox(height: 8),
                  TextButton(onPressed: () {}, child: Text('Add')),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Image(image: AssetImage('/assets/image/bear.png')),
            ),
          ],
        ),
      ),
    );
  }
}
