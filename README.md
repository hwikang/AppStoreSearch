# AppStore
# 프로젝트 설명

## 라이브러리

사용 라이브러리 - RxSwift, Snapkit, Alamofire

RxSwift 를 통해 비동기적인 이벤트 스트림을 핸들링 하였습니다. 

Snapkit 을 활용하여 레이아웃 제약조건 코드를 간결화 하였습니다. 

Alamofire 를 활용하여 HTTP 네트워크 호출을 구현 하였습니다.

## 프로젝트 구성

Clean Architecture 구조의 MVVM 패턴을 활용 하여 프로젝트를 구성했습니다.

Presentation , Domain, Data 레이어로 구분되어있고

Presentation → Domin ← Data 단방향 의존성 관리되어있습니다.

### Domain

Usecase, RepositoryProtocol, Entity 로 구성됩니다.

Entity - 네트워크 응답을 객체화 하기위한 NetworkResponse, AppListItem, AppDetailItem

에러 타입을 담은 NetworkError  이 포함됩니다.

NetworkResponse 의 경우 일관적인 네트워크 응답에 대응하여 제너릭 타입을 사용하여 다른 네트워크 호출에도 사용될수 있습니다.

```jsx

public struct NetworkResponse<T: Decodable>: Decodable {
    let resultCount: Int
    let results: [T]
    
}
```

Usecase - Repository 메소드를 호출하는 핵심 비즈니스 로직을 담당합니다.

저수준 모듈 Data 에 의존하지 않기 위해 RepositoryProtocol (추상화 인터페이스) 를 사용, 의존 하였습니다.

### Data

Network UseDefaults Repository 로 구성됩니다.

Network - http 네트워크 호출 담당 API 구현했으며 NetworkManager를 사용하여 중복되는 코드를 줄이고 여러 네트워크 호출에 활용됩니다. 

```jsx
 func fetchData<T:Decodable> (url: String, method: HTTPMethod, parameters: Parameters? = nil,
                                 encoding: ParameterEncoding = URLEncoding.default) async -> Result<T?, NetworkError>
```

UseDefaults - UseDefaults 통해 검색어 목록을 저장합니다.

Repository - Network, UseDefaults를 활용하여 원하는 데이터를 리턴해줍니다.

### Presentation

UI 부분을 담당하는 ViewController, ViewModel 이 있습니다.

MVVM 패턴으로 구성되었고 VM ←VC 간의 이벤트는 Input (VC→VM) Output(VM→VC) 로 정의되었습니다

```jsx
  
 public struct Input {
        let queryChange: Observable<String>
        let search: Observable<String>
    }
    
    public struct Output {
        let cellData: Observable<[AppListCellData]>
        let error: Observable<String>
    }
    
```

Output.cellData 를 통해 리스트에 쓰일 데이터가 전달됩니다. 탭의 상태, 정렬상태, 그리고 리스트를 활용하여 데이터 리스트를 구성합니다.

AppListCellData 는 associated value enum으로 구성되어 cell에 필요한 데이터를 전달합니다.

```jsx

public enum AppListCellData {
    case header(String)
    case query(String)
    case filteredQuery(String)
    case app(AppListItem)
    
}

```

ListType 에따라 검색어 필터검색어 앱목록을 노출하도록 cell data를 구성합니다

```jsx

    private func createCellData(listType: ListType, appList: [AppListItem], allQueryList: [String], filteredQueryList: [String]) -> [AppListCellData] {
        switch listType {
        case .app:
            return appList.map { AppListCellData.app($0) }
        case .filteredQuery:
            return filteredQueryList.map { AppListCellData.filteredQuery($0) }
        case .query:
            return  [AppListCellData.header("최근 검색어")] + allQueryList.map { AppListCellData.query($0) }
        }
    }
    
```

AppDetail 은 다양한 리스트 타입의 UI를 구현하기 위해 Compositional Layout + Diffable datasource로 구현했습니다.

ViewModel의 output에서 스냅샷을 리턴하도록 구현 했습니다

```jsx
 public struct Output {
        let snapshot: Observable<NSDiffableDataSourceSnapshot<AppDetailSecion, AppDetailCellData>>
        let error: Observable<String>
    }
```
