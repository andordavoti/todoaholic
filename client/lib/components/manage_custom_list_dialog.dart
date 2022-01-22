import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/custom_list.dart';
import 'package:todoaholic/data/lists_dao.dart';

class ManageCustomListDialog extends StatefulWidget {
  final CustomList? editList;

  const ManageCustomListDialog({Key? key, required this.editList})
      : super(key: key);

  @override
  State<ManageCustomListDialog> createState() => _ManageCustomListDialogState();
}

class _ManageCustomListDialogState extends State<ManageCustomListDialog> {
  final _textController = TextEditingController();
  final textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      SchedulerBinding.instance!.addPostFrameCallback((_) => {
            FocusScope.of(context).requestFocus(textFocusNode),
            _textController.text = widget.editList?.name ?? '',
          });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listsDao = Provider.of<ListsDao>(context, listen: false);
    final editList = widget.editList;

    void onSubmit() async {
      HapticFeedback.heavyImpact();
      final text = _textController.text.trim();

      if (editList != null) {
        if (text.isEmpty) {
          listsDao.remove(editList);
        } else {
          listsDao.update(editList, text);
        }
      } else {
        if (text.isNotEmpty) {
          listsDao.save(CustomList(name: text, order: 0));
        }
      }

      Navigator.of(context).pop(text);
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        editList != null ? 'Edit List' : 'Add List',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
          child: Text(editList != null ? "Edit" : "Add"),
          onPressed: onSubmit,
        ),
        editList != null
            ? OutlinedButton(
                child: const Text("Remove"),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  listsDao.remove(editList);
                  Navigator.of(context).pop(null);
                },
              )
            : const SizedBox.shrink(),
      ],
      actionsPadding: const EdgeInsets.only(bottom: 10),
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
        child: TextField(
          focusNode: textFocusNode,
          controller: _textController,
          onSubmitted: (_) {
            onSubmit();
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter list name here',
          ),
        ),
      ),
    );
  }
}
