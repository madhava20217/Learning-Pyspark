# Pyspark Notes

- Importing: from pyspark.sql import SparkSession
- Instantiation: spark = SparkSession.builder.appName('Name').getOrCreate()
- Reading from CSV: spark.read.csv('name')
  - Options: spark.read.option('header', 'true').csv('name', inferSchema = True)
    - Infers schema (data types) from the given data
    - Header = True does not include the first row in the dataframe and uses it as column names.
  - Can also use it as spark.read.csv('name', inferSchema = True, header = True)
- Selection: df_pyspark.select([columns]).show()
- Showing dataframe: df_pyspark.show()
- Dtypes: df_pyspark.dtypes
- Print Schema: df_pyspark.printSchema()
- Descriptive statistics: df_pyspark.describe().show(), need show because it returns as a dataframe object.
- Rename columns: df_pyspark.WithColumnsRenamed('Name', 'NewName').show()
  - Returns a dataframe object, have to show() or assign.
  - Not an inplace operation, like many others.
- Dropping na values: pyspark_df.na.drop().show()
  - Not an inplace operation.
  - Arguments to drop: how = 'any' and thresh = x
    - 'how' determines the row will be dropped
      - 'any': the row will be dropped if any column in na
      - 'all': the row will be dropped if all columns are na
    - 'thresh' determines how many columns in the entry should not be na.
      - Eg. thresh = 2 requires that at least 2 non-null columns be present in the row for it to not be dropped.
- Filling null values: df_pyspark.na.fill('Missing values').show()
  - Not an inplace operation, returns a dataframe object.
    - Arguments:
      - Missing value inpute: first argument which specifies by what the null values will be filled.
      - Second value is the columns to be scanned, in a list format.
    - Eg. df_pyspark.na.fill( 'Missing Values', [ 'Age', 'Experience' ] ).show() : replace na values with 'Missing Values' in 'Age' and 'Experience' columns.
- Imputer:
  - Import: from pyspark.ml.feature import Imputer
  - Instantiation: imputer = Imputer(inputCols: #list#, outputCols: #list#).setStrategy('strategy')
    - inputCols: columns that need to be imputed, required argument.
    - outputCols: output columns after imputation, required argument.
    - strategy: how the na values will be handled
      - mean
      - median
      - mode
  - Imputation: imputer.fit(df_pyspark).transform(df_pyspark).show()
    - Two different methods: fit and transform
    - Returns a dataframe object, needs to be assigned.
- Filter operations:
  - df_pyspark.filter('condition').show()
    - Returns a dataframe object, have to show() like in many instances before.
    - Similar to SQL selection.
  - Can also use: df_pyspark.filter(df_pyspark['column'] condition). **Ensure that the conditions are enclosed in braces while chaining**.
    - Eg. df_pyspark.filter( (df_pyspark['Salary'] < 20000) & (df_pyspark['Age'] < 25)).show()
    - Chain operations using **& or | or ! or ~ operators**, which stand for AND, OR, NOT respectively.
- GroupBy and Aggregate Functions:
  - GroupBy: df_pyspark.groupBy([list of columns]) {can use other functions as well, like sum()}
    - Returns a dataframe object, have to use .show()
  - Aggregation: something like groupBy but in a different format.
- Machine Learning using PySpark:
  - Group independent features into a column.
  - Use a VectorAssembler for that
    - Import: from pyspark.ml.feature import VectorAssembler
    - Init: featureassembler = VectorAssembler(inputCols = [list of input columns], outputCol = 'name of output column').
      - *Cannot use non-keyword initialisation.*
    - It combines inputCols into a vector as outputCol.
    - Transformation: featureassembler.transform(dataframe)
      - **Isn't an inplace operation, returns a dataframe**.
  - Machine Learning: From the same pyspark.ml.* library
    - Train-test Split:
      - Can use randomsplit method of pyspark dataframe:
        - train_data, test_data = df_pyspark.randomSplit([split ratios])
    - LinearRegression:
      - Import: from pyspark.ml.regression import LinearRegression
      - Init: regressor = LinearRegression(featureCols = 'feature column', labelCol = 'label column')
      - Fitting: regressor = regressor.fit(data)
        - Not an inplace operation, have to assign it somewhere.
      - Coefficients: regressor.coefficients
        - Will not be initialised for untrained model and will throw an error.
      - Intercept: regressor.intercept
      - Predictions:
        - Get predictions using- pred_results = regressor.evaluate(test_data)
        - Show predictions: pred_results.predictions.show()
        - Metrics: pred_results.meanAbsoluteError, pred_results.meanSquaredError, pred_results.rootMeanSquaredError
  