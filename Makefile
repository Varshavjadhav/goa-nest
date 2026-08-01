FEATURE ?= sample

#-------------------------------
# Generate Everything
#-------------------------------
generate:
	@echo "========================================="
	@echo "Running Flutter Project Generators"
	@echo "========================================="
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs
	dart run flutter_gen_runner
	flutter pub run intl_utils:generate
	@echo "========================================="
	@echo "Generation Completed Successfully"
	@echo "========================================="

#-------------------------------
# Watch Build Runner
#-------------------------------
watch:
	dart run build_runner watch --delete-conflicting-outputs

#-------------------------------
# Clean Generated Files
#-------------------------------
clean-generated:
	dart run build_runner clean

#-------------------------------
# Flutter Clean
#-------------------------------
clean:
	flutter clean
	flutter pub get

#-------------------------------
# Format Project
#-------------------------------
format:
	dart format .

#-------------------------------
# Analyze Project
#-------------------------------
analyze:
	flutter analyze

#-------------------------------
# Run Project
#-------------------------------
run:
	flutter run

#-------------------------------
# Build APK Debug
#-------------------------------
apk:
	flutter build apk

#-------------------------------
# Build APK Release
#-------------------------------
release:
	flutter build apk --release

BASE = lib/features/$(FEATURE)

CLASS = $(shell echo "$(FEATURE)" | awk -F_ '{for(i=1;i<=NF;i++) $$i=toupper(substr($$i,1,1)) substr($$i,2)}1' OFS="")

create-feature:
	@echo "Creating feature: $(FEATURE)"
	@echo "Class Name: $(CLASS)"

	@mkdir -p $(BASE)/data/datasource
	@mkdir -p $(BASE)/data/model
	@mkdir -p $(BASE)/data/repository
	@mkdir -p $(BASE)/domain/entity
	@mkdir -p $(BASE)/domain/repository
	@mkdir -p $(BASE)/domain/usecase
	@mkdir -p $(BASE)/presentation/bloc
	@mkdir -p $(BASE)/presentation/view
	@mkdir -p $(BASE)/presentation/widget

	@printf "abstract class $(CLASS)RemoteDataSource {}\n" > $(BASE)/data/datasource/$(FEATURE)_remote_datasource.dart

	@printf "class $(CLASS)Model {}\n" > $(BASE)/data/model/$(FEATURE)_model.dart

	@printf "import '../../domain/repository/$(FEATURE)_repository.dart';\n\nclass $(CLASS)RepositoryImpl implements $(CLASS)Repository {}\n" > $(BASE)/data/repository/$(FEATURE)_repository_impl.dart

	@printf "class $(CLASS)Entity {}\n" > $(BASE)/domain/entity/$(FEATURE)_entity.dart

	@printf "abstract class $(CLASS)Repository {}\n" > $(BASE)/domain/repository/$(FEATURE)_repository.dart

	@printf "import '../repository/$(FEATURE)_repository.dart';\n\nclass Get$(CLASS)UseCase {\n  final $(CLASS)Repository repository;\n\n  const Get$(CLASS)UseCase(this.repository);\n}\n" > $(BASE)/domain/usecase/get_$(FEATURE).dart

	@printf "abstract class $(CLASS)Event {}\n\nclass Load$(CLASS) extends $(CLASS)Event {}\n" > $(BASE)/presentation/bloc/$(FEATURE)_event.dart

	@printf "abstract class $(CLASS)State {}\n\nclass $(CLASS)Initial extends $(CLASS)State {}\nclass $(CLASS)Loading extends $(CLASS)State {}\nclass $(CLASS)Loaded extends $(CLASS)State {}\nclass $(CLASS)Error extends $(CLASS)State {\n  final String message;\n  $(CLASS)Error(this.message);\n}\n" > $(BASE)/presentation/bloc/$(FEATURE)_state.dart

	@printf "import 'package:flutter_bloc/flutter_bloc.dart';\nimport '$(FEATURE)_event.dart';\nimport '$(FEATURE)_state.dart';\n\nclass $(CLASS)Bloc extends Bloc<$(CLASS)Event, $(CLASS)State> {\n  $(CLASS)Bloc() : super($(CLASS)Initial()) {\n    on<Load$(CLASS)>((event, emit) {\n      // TODO: Implement\n    });\n  }\n}\n" > $(BASE)/presentation/bloc/$(FEATURE)_bloc.dart

	@printf "import 'package:flutter/material.dart';\n\nclass $(CLASS)Screen extends StatelessWidget {\n  const $(CLASS)Screen({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return const Scaffold(\n      body: Center(\n        child: Text('$(CLASS) Screen'),\n      ),\n    );\n  }\n}\n" > $(BASE)/presentation/view/$(FEATURE)_screen.dart

	@printf "import 'package:flutter/material.dart';\n\nclass $(CLASS)Widget extends StatelessWidget {\n  const $(CLASS)Widget({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return const SizedBox.shrink();\n  }\n}\n" > $(BASE)/presentation/widget/$(FEATURE)_widget.dart

	@printf "export 'presentation/view/$(FEATURE)_screen.dart';\nexport 'presentation/bloc/$(FEATURE)_bloc.dart';\nexport 'presentation/bloc/$(FEATURE)_event.dart';\nexport 'presentation/bloc/$(FEATURE)_state.dart';\n" > $(BASE)/$(FEATURE).dart

	@echo "✅ Feature '$(FEATURE)' created successfully."
#-------------------------------
# Help
#-------------------------------
help:
	@echo ""
	@echo "Available Commands"
	@echo ""
	@echo "make generate"
	@echo "make watch"
	@echo "make clean"
	@echo "make repair"
	@echo "make format"
	@echo "make analyze"
	@echo "make run"
	@echo "make apk"
	@echo "make release"
	@echo "make create-feature FEATURE=login"
	@echo "make feature FEATURE=login"




