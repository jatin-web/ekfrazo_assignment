/// Resolves `{{fieldName}}` placeholders against the form state map.
/// Shared by toast messages, template text, and label/value pairs.
/// "hello {{name}}, you have successfully cleared {{examName}} exam."
/// {"name" : "jatin"}
class TemplateResolver {
  // Prevent object instantiation from outside the class
  const TemplateResolver._();

  static final RegExp _placeholder = RegExp(r'\{\{(\w+)\}\}');

  static String resolve(String template, Map<String, String> data) {
    return template.replaceAllMapped(
      _placeholder,
      (match) => data[match.group(1)] ?? '',
    );
  }
}
