import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/GlobalWidgets/RoundedButton.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:nawras_app/Providers/OtherProvider.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void onSubmit(BuildContext context) async {
    final otherProvider = Provider.of<OtherProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    otherProvider.feedbackRequest(
        token: auth.session.mainToken,
        title: titleController.text,
        name: nameController.text,
        message: messageController.text);
  }

  @override
  Widget build(BuildContext context) {
    final words = Provider.of<Language>(context).words;
    return Direction(
      child: Scaffold(
        appBar: AppBar(
          title: Text(words["feedback"]),
        ),
        body: ListView(
          children: [
            Form(
              key: _formKey,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        words["feedback-title"],
                        style: AppTextStyle.boldTitle24,
                      ),
                      SizedBox(height: 15),
                      Text(words["feedback-desc"]),
                      Text('Let us know in field below'),
                      SizedBox(height: 30),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: words["title"],
                            border: InputBorder.none,
                            fillColor: PaletteColors.greyColorApp,
                            filled: true,
                          ),
                          validator: (text) {
                            if (text.length < 2) {
                              return words["valid-title"];
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: TextFormField(
                          textDirection: TextDirection.ltr,
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: words["name"],
                            border: InputBorder.none,
                            fillColor: PaletteColors.greyColorApp,
                            filled: true,
                          ),
                          validator: (text) {
                            if (text.length < 2) {
                              return words["valid-name"];
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(words["title-desc"]),
                      SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: TextFormField(
                          controller: messageController,
                          maxLines: 20,
                          decoration: InputDecoration(
                            hintText: words["desc-desc"],
                            border: InputBorder.none,
                            fillColor: PaletteColors.greyColorApp,
                            filled: true,
                          ),
                          validator: (text) {
                            if (text.length < 5) {
                              return words["valid-message"];
                            } else {
                              return null;
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 30),
              child: RoundedButton(
                title: 'Send',
                onPressed: () => onSubmit(context),
                color: PaletteColors.darkRedColorApp,
              ),
            )
          ],
        ),
      ),
    );
  }
}
