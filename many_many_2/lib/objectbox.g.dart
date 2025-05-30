// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 3381747796728220507),
      name: 'Event',
      lastPropertyId: const IdUid(4, 4920123070826450488),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7709421869102031974),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 8067796492552408655),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3955979154529619865),
            name: 'date',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4920123070826450488),
            name: 'location',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'tasks', srcEntity: 'Task', srcField: 'event')
      ]),
  ModelEntity(
      id: const IdUid(2, 623646986822324082),
      name: 'Owner',
      lastPropertyId: const IdUid(2, 403281848334679014),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5077350209314406947),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 403281848334679014),
            name: 'name',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'tasks', srcEntity: 'Task', srcField: '')
      ]),
  ModelEntity(
      id: const IdUid(3, 8085257960348555831),
      name: 'Task',
      lastPropertyId: const IdUid(4, 5568958378956175777),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5044693393643969344),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 3148930984345521812),
            name: 'text',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 4205813018151760972),
            name: 'status',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5568958378956175777),
            name: 'eventId',
            type: 11,
            flags: 520,
            indexId: const IdUid(1, 7870134188562425503),
            relationTarget: 'Event')
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(1, 7788834360439378994),
            name: 'owner',
            targetId: const IdUid(2, 623646986822324082))
      ],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(3, 8085257960348555831),
      lastIndexId: const IdUid(1, 7870134188562425503),
      lastRelationId: const IdUid(1, 7788834360439378994),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Event: EntityDefinition<Event>(
        model: _entities[0],
        toOneRelations: (Event object) => [],
        toManyRelations: (Event object) => {
              RelInfo<Task>.toOneBacklink(
                      4, object.id, (Task srcObject) => srcObject.event):
                  object.tasks
            },
        getId: (Event object) => object.id,
        setId: (Event object, int id) {
          object.id = id;
        },
        objectToFB: (Event object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final locationOffset = object.location == null
              ? null
              : fbb.writeString(object.location!);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.date?.millisecondsSinceEpoch);
          fbb.addOffset(3, locationOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final dateValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 8);
          final object = Event(
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              date: dateValue == null
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(dateValue),
              location: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 10));
          InternalToManyAccess.setRelInfo(
              object.tasks,
              store,
              RelInfo<Task>.toOneBacklink(
                  4, object.id, (Task srcObject) => srcObject.event),
              store.box<Event>());
          return object;
        }),
    Owner: EntityDefinition<Owner>(
        model: _entities[1],
        toOneRelations: (Owner object) => [],
        toManyRelations: (Owner object) =>
            {RelInfo<Task>.toManyBacklink(1, object.id): object.tasks},
        getId: (Owner object) => object.id,
        setId: (Owner object, int id) {
          object.id = id;
        },
        objectToFB: (Owner object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Owner(
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0));
          InternalToManyAccess.setRelInfo(object.tasks, store,
              RelInfo<Task>.toManyBacklink(1, object.id), store.box<Owner>());
          return object;
        }),
    Task: EntityDefinition<Task>(
        model: _entities[2],
        toOneRelations: (Task object) => [object.event],
        toManyRelations: (Task object) =>
            {RelInfo<Task>.toMany(1, object.id): object.owner},
        getId: (Task object) => object.id,
        setId: (Task object, int id) {
          object.id = id;
        },
        objectToFB: (Task object, fb.Builder fbb) {
          final textOffset = fbb.writeString(object.text);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, textOffset);
          fbb.addBool(2, object.status);
          fbb.addInt64(3, object.event.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Task(
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              status: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 8, false));
          object.event.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0);
          object.event.attach(store);
          InternalToManyAccess.setRelInfo(object.owner, store,
              RelInfo<Task>.toMany(1, object.id), store.box<Task>());
          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Event] entity fields to define ObjectBox queries.
class Event_ {
  /// see [Event.id]
  static final id = QueryIntegerProperty<Event>(_entities[0].properties[0]);

  /// see [Event.name]
  static final name = QueryStringProperty<Event>(_entities[0].properties[1]);

  /// see [Event.date]
  static final date = QueryIntegerProperty<Event>(_entities[0].properties[2]);

  /// see [Event.location]
  static final location =
      QueryStringProperty<Event>(_entities[0].properties[3]);
}

/// [Owner] entity fields to define ObjectBox queries.
class Owner_ {
  /// see [Owner.id]
  static final id = QueryIntegerProperty<Owner>(_entities[1].properties[0]);

  /// see [Owner.name]
  static final name = QueryStringProperty<Owner>(_entities[1].properties[1]);
}

/// [Task] entity fields to define ObjectBox queries.
class Task_ {
  /// see [Task.id]
  static final id = QueryIntegerProperty<Task>(_entities[2].properties[0]);

  /// see [Task.text]
  static final text = QueryStringProperty<Task>(_entities[2].properties[1]);

  /// see [Task.status]
  static final status = QueryBooleanProperty<Task>(_entities[2].properties[2]);

  /// see [Task.event]
  static final event =
      QueryRelationToOne<Task, Event>(_entities[2].properties[3]);

  /// see [Task.owner]
  static final owner =
      QueryRelationToMany<Task, Owner>(_entities[2].relations[0]);
}
