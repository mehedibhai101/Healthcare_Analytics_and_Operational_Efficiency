let
    // Accessed the geographical master list from the local directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Targeted the specific binary content for the city and state mapping file.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="cities.csv"]}[Content],

    // Imported the CSV document with a 3-column schema (ID, City, and State).
    Imported_City_Data = Csv.Document(File_Content,[Delimiter=",", Columns=3, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify regional levels.
    Promote_Headers = Table.PromoteHeaders(Imported_City_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to support map-based visuals and regional filtering.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"City ID", Int64.Type}, 
        {"City", type text}, 
        {"State", type text}
    }),

    // Renamed headers to follow a professional naming convention for GIS and BI reporting.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"City", "City Name"},
        {"State", "State/Province"}
    })
in
    Renamed_Columns
