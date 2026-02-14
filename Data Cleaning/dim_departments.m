let
    // Accessed the hospital department master list from the local directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Targeted the specific binary content for the healthcare departments file.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="department.csv"]}[Content],

    // Imported the CSV document with a 2-column schema (ID and Department Name).
    Imported_Dept_Data = Csv.Document(File_Content,[Delimiter=",", Columns=2, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify department codes and names.
    Promote_Headers = Table.PromoteHeaders(Imported_Dept_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to support efficient filtering across clinical dashboards.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"Department ID", Int64.Type}, 
        {"Department", type text}
    }),

    // Standardized the Department names by simplifying "General Surgery" to "General".
    // This aligns the naming convention if other departments are also short-form.
    Clean_Dept_Names = Table.ReplaceValue(Set_Data_Types,"General Surgery","General",Replacer.ReplaceText,{"Department"}),

    // Renamed headers to follow professional hospital administration standards.
    Renamed_Columns = Table.RenameColumns(Clean_Dept_Names,{
        {"Department", "Department Name"}
    })
in
    Renamed_Columns
