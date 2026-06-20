import 'dart:io';
import 'package:aoun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:aoun/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import '../cubit/chat_cubit.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;

  const ChatInputBar({super.key, required this.controller});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final SpeechToText _speech = SpeechToText();
  final ImagePicker _picker = ImagePicker();

  bool _isListening = false;
  XFile? _pickedImage;
  TextDirection _textDirection = TextDirection.ltr;

  /// -------------------
  /// MICROPHONE METHODS
  /// -------------------
  Future<void> _startListening() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) return;

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == "done" || status == "notListening") {
          _stopListening();
        }
      },
      onError: (error) => debugPrint("Speech error: $error"),
    );

    if (available) {
      setState(() => _isListening = true);

      _speech.listen(
        onResult: (result) {
          widget.controller.text = result.recognizedWords;
          _updateTextDirection(result.recognizedWords);
        },
        listenFor: const Duration(seconds: 60),
        localeId: WidgetsBinding.instance.window.locale.languageCode,
        cancelOnError: true,
        partialResults: true,
        listenMode: ListenMode.dictation,
      );
    }
  }

  Future<void> _stopListening() async {
    if (!_isListening) return;
    await _speech.stop();
    setState(() => _isListening = false);
  }

  /// -------------------
  /// IMAGE METHODS
  /// -------------------
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  /// Remove selected image
  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  /// -------------------
  /// SEND LOGIC
  /// -------------------
  void _sendMessage() {
    final text = widget.controller.text.trim();

    if (_pickedImage != null) {
      context.read<ChatCubit>().sendMediaMessage(
        _pickedImage!.path,
        MessageType.image,
        message: text.isEmpty ? null : text,
      );
      _pickedImage = null;
      widget.controller.clear();
      _textDirection = TextDirection.ltr;
      return;
    }

    if (text.isNotEmpty) {
      context.read<ChatCubit>().sendTextMessage(text);
      widget.controller.clear();
      _textDirection = TextDirection.ltr;
    }
  }

  /// -------------------
  /// TEXT DIRECTION DETECTION
  /// -------------------
  void _updateTextDirection(String input) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    setState(() {
      _textDirection = arabicRegex.hasMatch(input)
          ? TextDirection.rtl
          : TextDirection.ltr;
    });
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Selected image thumbnail with remove button
          if (_pickedImage != null)
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(File(_pickedImage!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: -5,
                  right: -5,
                  child: GestureDetector(
                    onTap: _removeImage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          // Text input
          Expanded(
            child: TextField(
              controller: widget.controller,
              textDirection: _textDirection,

              decoration: InputDecoration(
                hintText: _pickedImage != null ? t.addCaption : t.typeOrSpeak,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onLongPressStart: (_) => _startListening(),
                      onLongPressEnd: (_) => _stopListening(),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : Colors.blue,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    IconButton(
                      icon: const Icon(Icons.image, color: Colors.blue),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onChanged: _updateTextDirection,
            ),
          ),
          SizedBox(width: 5.w),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
