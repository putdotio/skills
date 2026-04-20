# SDK Patterns

Use these examples when a put.io SDK repo needs concrete implementation shape and the repo does not already establish a stronger local pattern.

## TypeScript

Keep boundary parsing explicit and keep Promise and Effect surfaces aligned:

```ts
const FileSchema = Schema.Struct({
  id: Schema.Number,
  name: Schema.String,
  content_type: Schema.NullOr(Schema.String),
});

export type PutioFile = Schema.Schema.Type<typeof FileSchema>;

export const listFiles = (client: PutioSdkClient, input: ListFilesInput) =>
  client.get("/files/list", { query: input }).pipe(
    selectJsonField("files"),
    Effect.flatMap(Schema.decodeUnknown(Schema.Array(FileSchema))),
    withOperationErrors(ListFilesErrorSpec),
  );
```

Prefer discriminated unions and parameter-aware types over loose bags:

```ts
type SubtitleResult =
  | { readonly kind: "available"; readonly subtitles: ReadonlyArray<Subtitle> }
  | { readonly kind: "missing" };
```

Avoid unsafe casts, ignored type failures, and ad hoc JSON parsing when `Schema` already covers the boundary.

## Kotlin

Model backend state with explicit types and tolerate forward-compatible backend values where needed:

```kotlin
@Serializable
data class PutioFile(
    val id: Long,
    val name: String,
    @SerialName("content_type") val contentType: String? = null,
)

@JvmInline
@Serializable(with = PutioFileTypeSerializer::class)
value class PutioFileType(val raw: String) {
    val isKnown: Boolean get() = raw in setOf("VIDEO", "AUDIO", "FOLDER")
}
```

Keep coroutine APIs domain-first and keep request, response, and error models updated together.

## Swift

Keep public contracts explicit and preserve a stable package surface:

```swift
public struct AccountInfo: Decodable, Sendable {
    public let username: String
    public let mail: String
}

public enum PutioSDKError: Error, Sendable {
    case transport(TransportError)
    case api(status: Int, message: String)
    case decoding(DecodingError)
}
```

Use the example app for auth-flow and integration smoke checks when a formal live harness is not available yet.

## Verification Layers

Healthy SDK repos should keep two layers distinct:

- Unit or contract tests for request shaping, parsing, error mapping, and multi-client alignment
- Safe live tests for real API behavior, conditional backend fields, and reversible mutations

Representative shapes in this workspace:

```bash
vp run verify
vp run test:live
./gradlew verify
./gradlew liveTest
make verify
```

If a repo only has one layer today, document the gap and prefer adding the missing layer over widening claims about verification quality.
