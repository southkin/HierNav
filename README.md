# HierNav
A view that automatically configures NavigationSplitView or NavigationStack based on platform and layout conditions.

## HierNav
```swift
HierNav(style: <#style#>) {
    <#contents#> //your content
}
```
### style
```swift
case single
case split2Columns(Set<PlatformOption>)
case split3Columns(Set<PlatformOption>)
```
- .single
  >Always uses a single stack view regardless of screen resolution
- .split2columns
  ```mermaid
  flowchart TD
  existsOptions{{"if let option = options.filter{$0 == Platform.current}"}}
  checkWidth{{"option.minWidth*2 >= currentWidth"}}
  if_iOS{{"Platform.current == .iOS"}}
  widthIsCompact{{"UserInterfaceSizeClass == .compact"}}
  two["2 column SplitView"]
  one["fullSize StackView"]
  existsOptions --false--> one
  widthIsCompact --true--> one
  checkWidth --false--> one
  existsOptions --true--> if_iOS
  if_iOS --true--> widthIsCompact
  if_iOS --false--> checkWidth
  widthIsCompact --false--> checkWidth
  checkWidth --true--> two
  ```
- .split3columns
  ```mermaid
  flowchart TD
  existsOptions{{"if let option = options.filter{$0 == Platform.current}"}}
  checkWidth{{"option.minWidth*3 >= currentWidth"}}
  checkWidthNext{{"option.minWidth*2 >= currentWidth"}}
  if_iOS{{"Platform.current == .iOS"}}
  widthIsCompact{{"UserInterfaceSizeClass == .compact"}}
  three["3 column SplitView"]
  two["2 column SplitView"]
  one["fullSize StackView"]
  existsOptions --false--> one
  widthIsCompact --true--> one
  checkWidth --false--> checkWidthNext
  existsOptions --true--> if_iOS
  if_iOS --true--> widthIsCompact
  if_iOS --false--> checkWidth
  widthIsCompact --false--> checkWidth
  checkWidth --true----> three
  checkWidthNext --true--> two
  checkWidthNext --false--> one
  ```

#### PlatformOption
```swift
case mac(minWidth: Double)
case iOS(minWidth: Double)
```
## HNLink
```swift
HNLink(
    <#View#>, //visible View
    actionType: <#HNType#>
) {
    <#Destination View#> //NextView
}
```
>HNLink must be inside HierNav

### View
some View
### HNType
```swift
case push
case present
case popover
```
>watchOS : Always behaves as push regardless of the specified type
### Convenience Initializers
- _ title: String
  ```swift
  public init(
      _ title: String,
      actionType: HNType,
      @ViewBuilder destination: @escaping () -> Destination
  )
  ```
- systemImage systemName: String
  ```swift
  public init(
      systemImage systemName: String,
      actionType: HNType,
      @ViewBuilder destination: @escaping () -> Destination
  )
  ```
