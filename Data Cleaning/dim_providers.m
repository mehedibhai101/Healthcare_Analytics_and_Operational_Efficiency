let
    // Accessed the provider master data from the local directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Targeted the specific binary content for the healthcare providers file.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="providers.csv"]}[Content],

    // Imported the CSV document with a 6-column schema.
    Imported_Provider_Data = Csv.Document(File_Content,[Delimiter=",", Columns=6, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify provider demographics and IDs.
    Promote_Headers = Table.PromoteHeaders(Imported_Provider_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to facilitate demographic grouping and age-based analysis.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"Provider ID", Int64.Type}, 
        {"Provider Name", type text}, 
        {"Gender", type text}, 
        {"Nationality", type text}, 
        {"Age", Int64.Type}, 
        {"Image", type text}
    }),

    // Removed the 'Image' column to optimize the data model size and maintain focus on quantitative metrics.
    Remove_Image_Column = Table.RemoveColumns(Set_Data_Types,{"Image"}),

    // Renamed headers to maintain a professional, standardized naming convention for hospital dashboards.
    Renamed_Columns = Table.RenameColumns(Remove_Image_Column,{
        {"Provider Name", "Doctor Name"},
        {"Nationality", "Origin"},
        {"Age", "Provider Age"}
    })
in
    Renamed_Columns
