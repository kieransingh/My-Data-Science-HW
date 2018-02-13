

```
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os
```


```
purchasing_data = os.path.join('purchase_data.json')
purchasing_data2 = os.path.join('purchase_data2.json')
```


```
purchase_df = pd.read_json(purchasing_data)
purchase_df2 = pd.read_json(purchasing_data2)
purchase_df.head()
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Age</th>
      <th>Gender</th>
      <th>Item ID</th>
      <th>Item Name</th>
      <th>Price</th>
      <th>SN</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>38</td>
      <td>Male</td>
      <td>165</td>
      <td>Bone Crushing Silver Skewer</td>
      <td>3.37</td>
      <td>Aelalis34</td>
    </tr>
    <tr>
      <th>1</th>
      <td>21</td>
      <td>Male</td>
      <td>119</td>
      <td>Stormbringer, Dark Blade of Ending Misery</td>
      <td>2.32</td>
      <td>Eolo46</td>
    </tr>
    <tr>
      <th>2</th>
      <td>34</td>
      <td>Male</td>
      <td>174</td>
      <td>Primitive Blade</td>
      <td>2.46</td>
      <td>Assastnya25</td>
    </tr>
    <tr>
      <th>3</th>
      <td>21</td>
      <td>Male</td>
      <td>92</td>
      <td>Final Critic</td>
      <td>1.36</td>
      <td>Pheusrical25</td>
    </tr>
    <tr>
      <th>4</th>
      <td>23</td>
      <td>Male</td>
      <td>63</td>
      <td>Stormfury Mace</td>
      <td>1.27</td>
      <td>Aela59</td>
    </tr>
  </tbody>
</table>
</div>




```
#find the total number of players
total_players=len(purchase_df["SN"].unique())
total_players_df = pd.DataFrame({"Number of Players":[total_players]})
total_players_df
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Number of Players</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>573</td>
    </tr>
  </tbody>
</table>
</div>



#Pricing analysis (Total)


```
#number of unique items
items = len(purchase_df["Item Name"].unique())
items
```




    179




```
#average purchase price
avg_purchase_price = round(purchase_df["Price"].mean(), 2)
avg_purchase_price
```




    2.93




```
#total number of purchases
total_purchases = len(purchase_df)
total_purchases
```




    780




```
#total revnue
total_revenue = (total_purchases*avg_purchase_price)
total_revenue

```




    2285.4




```
purch_analysis_tot = pd.DataFrame([{"# of Items": items,
                                  "Avgerage Purchase Price": avg_purchase_price,
                                  "Total Purchases": total_purchases,
                                  "Total Revenue": total_revenue}])
purch_analysis_tot.style.format({'Average Purchase Price': '${:.2f}', 'Total Revenue':''})
purch_analysis_tot
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th># of Items</th>
      <th>Avgerage Purchase Price</th>
      <th>Total Purchases</th>
      <th>Total Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>179</td>
      <td>2.93</td>
      <td>780</td>
      <td>2285.4</td>
    </tr>
  </tbody>
</table>
</div>




```
# Gender Demographics
# first need to drop out duplicates in order to get a real gender count

dropped = purchase_df.drop_duplicates(["SN"])

#index must be reset in order to get percent of players in next step

gender_counts = dropped["Gender"].value_counts().reset_index()

# Percentage and Count of Male Players
# Percentage and Count of Female Players
# Percentage and Count of Male Players
# Percentage and Count of Female Players
# Percentage and Count of Other / Non-Disclosed


gender_counts["% of Players"] = round((gender_counts['Gender']/total_players)*100, 1)
gender_counts = gender_counts.rename(columns={"index":"Gender", "Gender":"# of Players"}, inplace=True)
gender_counts
gender_counts_df =pd.DataFrame(gender_counts)
gender_counts_df
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
    </tr>
  </thead>
  <tbody>
  </tbody>
</table>
</div>



# Purchasing analysis (Gender)


```
# The below each broken by gender
# Purchase Count
# Average Purchase Price
# Total Purchase Value
# Normalized Totals

purch_count = pd.DataFrame(purchase_df.groupby("Gender")['Gender'].count())
purch_count = (purch_count.rename(columns={"Gender" : "# of Purchases"}))
#both variables are grouped by Gender
total_purch_gender = pd.DataFrame(purchase_df.groupby("Gender")['Price'].sum())
total_purch_gender = total_purch_gender.rename(columns={'Price':'Total Purchase Value'})

gender_total_analysis = pd.merge(purch_count, total_purch_gender, left_index = True, right_index=True)
gender_total_analysis["Average Purchase Price"] = round(gender_total_analysis['Total Purchase Value']/gender_total_analysis['# of Purchases'],2)

#normalized totals = Total Purchase Value/# of players in respective gender. Normalized total shows average spent
#spread across total number of players rather than over quantity of transactions
??????????????????
#gender_total_analysis["Normalized Totals"] = round((gender_total_analysis["Total Purchase Value"]/gender_counts["# of Players"]), 2)

gender_total_analysis
```

    Object `` not found.





<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th># of Purchases</th>
      <th>Total Purchase Value</th>
      <th>Average Purchase Price</th>
    </tr>
    <tr>
      <th>Gender</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Female</th>
      <td>136</td>
      <td>382.91</td>
      <td>2.82</td>
    </tr>
    <tr>
      <th>Male</th>
      <td>633</td>
      <td>1867.68</td>
      <td>2.95</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>11</td>
      <td>35.74</td>
      <td>3.25</td>
    </tr>
  </tbody>
</table>
</div>



Age Demographics


```
age_bins = [0,9,15,20,25,32,45,100]
bin_labels = ['<10', '10-15', '16-20', '21-25', '26-32', '33-45', '45>']
purchase_df["Age Demographics"] = pd.cut(purchase_df["Age"], age_bins, labels=bin_labels)
demographic_group = purchase_df.groupby("Age Demographics")
dem_group_df = pd.DataFrame(demographic_group["Age"].count())
dem_group_count = dem_group_df.rename(columns={"Age":'Number of People'})
dem_total_value = round(demographic_group["Price"].sum(), 2)
dem_avg_purch = round(demographic_group["Price"].mean(), 2)


dem_group_count_df = pd.DataFrame(dem_group_count)
dem_total_df = pd.DataFrame(dem_total_value)
dem_avg_purch_df = pd.DataFrame(dem_avg_purch)
dem_avg_purch_df = dem_avg_purch_df.rename(columns={"Price":'Avg. Purchase Price'})
dem_total_df = dem_total_df.rename(columns={"Price":'Total Purchase Value'})
combined_df = pd.merge(dem_group_count_df, dem_total_df, left_index=True, right_index=True)
combined_df = pd.merge(combined_df, dem_avg_purch_df, left_index=True, right_index=True)
combined_df = combined_df.rename(columns={"Number of People":'Purchase Count'})
combined_df = combined_df.fillna("No Data")
combined_df = combined_df.style.format({' Total Purchase Value': '${:.2f}', 'Avg. Purchase price': '${:.2F}'})
combined_df
```




<style  type="text/css" >
</style>  
<table id="T_bc909476_1107_11e8_9fe6_f200c432c501" > 
<thead>    <tr> 
        <th class="blank level0" ></th> 
        <th class="col_heading level0 col0" >Purchase Count</th> 
        <th class="col_heading level0 col1" >Total Purchase Value</th> 
        <th class="col_heading level0 col2" >Avg. Purchase Price</th> 
    </tr>    <tr> 
        <th class="index_name level0" >Age Demographics</th> 
        <th class="blank" ></th> 
        <th class="blank" ></th> 
        <th class="blank" ></th> 
    </tr></thead> 
<tbody>    <tr> 
        <th id="T_bc909476_1107_11e8_9fe6_f200c432c501level0_row0" class="row_heading level0 row0" ><10</th> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row0_col0" class="data row0 col0" >28</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row0_col1" class="data row0 col1" >83.46</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row0_col2" class="data row0 col2" >2.98</td> 
    </tr>    <tr> 
        <th id="T_bc909476_1107_11e8_9fe6_f200c432c501level0_row1" class="row_heading level0 row1" >10-15</th> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row1_col0" class="data row1 col0" >82</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row1_col1" class="data row1 col1" >237.31</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row1_col2" class="data row1 col2" >2.89</td> 
    </tr>    <tr> 
        <th id="T_bc909476_1107_11e8_9fe6_f200c432c501level0_row2" class="row_heading level0 row2" >16-20</th> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row2_col0" class="data row2 col0" >184</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row2_col1" class="data row2 col1" >528.74</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row2_col2" class="data row2 col2" >2.87</td> 
    </tr>    <tr> 
        <th id="T_bc909476_1107_11e8_9fe6_f200c432c501level0_row3" class="row_heading level0 row3" >21-25</th> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row3_col0" class="data row3 col0" >305</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row3_col1" class="data row3 col1" >902.61</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row3_col2" class="data row3 col2" >2.96</td> 
    </tr>    <tr> 
        <th id="T_bc909476_1107_11e8_9fe6_f200c432c501level0_row4" class="row_heading level0 row4" >26-32</th> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row4_col0" class="data row4 col0" >103</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row4_col1" class="data row4 col1" >304.94</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row4_col2" class="data row4 col2" >2.96</td> 
    </tr>    <tr> 
        <th id="T_bc909476_1107_11e8_9fe6_f200c432c501level0_row5" class="row_heading level0 row5" >33-45</th> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row5_col0" class="data row5 col0" >78</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row5_col1" class="data row5 col1" >229.27</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row5_col2" class="data row5 col2" >2.94</td> 
    </tr>    <tr> 
        <th id="T_bc909476_1107_11e8_9fe6_f200c432c501level0_row6" class="row_heading level0 row6" >45></th> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row6_col0" class="data row6 col0" >0</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row6_col1" class="data row6 col1" >No Data</td> 
        <td id="T_bc909476_1107_11e8_9fe6_f200c432c501row6_col2" class="data row6 col2" >No Data</td> 
    </tr></tbody> 
</table> 



Top Spenders



```
purchase_df.head()
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Age</th>
      <th>Gender</th>
      <th>Item ID</th>
      <th>Item Name</th>
      <th>Price</th>
      <th>SN</th>
      <th>Age Demographics</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>38</td>
      <td>Male</td>
      <td>165</td>
      <td>Bone Crushing Silver Skewer</td>
      <td>3.37</td>
      <td>Aelalis34</td>
      <td>33-45</td>
    </tr>
    <tr>
      <th>1</th>
      <td>21</td>
      <td>Male</td>
      <td>119</td>
      <td>Stormbringer, Dark Blade of Ending Misery</td>
      <td>2.32</td>
      <td>Eolo46</td>
      <td>21-25</td>
    </tr>
    <tr>
      <th>2</th>
      <td>34</td>
      <td>Male</td>
      <td>174</td>
      <td>Primitive Blade</td>
      <td>2.46</td>
      <td>Assastnya25</td>
      <td>33-45</td>
    </tr>
    <tr>
      <th>3</th>
      <td>21</td>
      <td>Male</td>
      <td>92</td>
      <td>Final Critic</td>
      <td>1.36</td>
      <td>Pheusrical25</td>
      <td>21-25</td>
    </tr>
    <tr>
      <th>4</th>
      <td>23</td>
      <td>Male</td>
      <td>63</td>
      <td>Stormfury Mace</td>
      <td>1.27</td>
      <td>Aela59</td>
      <td>21-25</td>
    </tr>
  </tbody>
</table>
</div>




```
purch_amount_by_SN = pd.DataFrame(purchase_df.groupby('SN')['Price'].sum())
num_purch_by_SN = pd.DataFrame(purchase_df.groupby('SN')['Price'].count())
avg_by_SN = pd.DataFrame(purchase_df.groupby('SN')['Price'].mean())
top_5_spenders = pd.merge(purch_amount_by_SN, num_purch_by_SN, left_index = True, right_index=True).merge(avg_by_SN, left_index=True, right_index=True)
top_5_spenders = top_5_spenders.rename(columns={'Price_x':'Total Purchase Value', 'Price_y':'Quantity of Purchases', 'Price':'Avgerage Purchase Price'})
top_5_spenders.sort_values('Total Purchase Value', ascending=False, inplace=True )
top_5_spenders = top_5_spenders.head()
top_5_spenders = top_5_spenders.style.format({'Total Purchase Value': '${:.2f}', 'Average Purchase Price': '${:.2f}'})
top_5_spenders 
```




<style  type="text/css" >
</style>  
<table id="T_943a45fe_110b_11e8_8ae2_f200c432c501" > 
<thead>    <tr> 
        <th class="blank level0" ></th> 
        <th class="col_heading level0 col0" >Total Purchase Value</th> 
        <th class="col_heading level0 col1" >Quantity of Purchases</th> 
        <th class="col_heading level0 col2" >Avgerage Purchase Price</th> 
    </tr>    <tr> 
        <th class="index_name level0" >SN</th> 
        <th class="blank" ></th> 
        <th class="blank" ></th> 
        <th class="blank" ></th> 
    </tr></thead> 
<tbody>    <tr> 
        <th id="T_943a45fe_110b_11e8_8ae2_f200c432c501level0_row0" class="row_heading level0 row0" >Undirrala66</th> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row0_col0" class="data row0 col0" >$17.06</td> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row0_col1" class="data row0 col1" >5</td> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row0_col2" class="data row0 col2" >3.412</td> 
    </tr>    <tr> 
        <th id="T_943a45fe_110b_11e8_8ae2_f200c432c501level0_row1" class="row_heading level0 row1" >Saedue76</th> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row1_col0" class="data row1 col0" >$13.56</td> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row1_col1" class="data row1 col1" >4</td> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row1_col2" class="data row1 col2" >3.39</td> 
    </tr>    <tr> 
        <th id="T_943a45fe_110b_11e8_8ae2_f200c432c501level0_row2" class="row_heading level0 row2" >Mindimnya67</th> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row2_col0" class="data row2 col0" >$12.74</td> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row2_col1" class="data row2 col1" >4</td> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row2_col2" class="data row2 col2" >3.185</td> 
    </tr>    <tr> 
        <th id="T_943a45fe_110b_11e8_8ae2_f200c432c501level0_row3" class="row_heading level0 row3" >Haellysu29</th> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row3_col0" class="data row3 col0" >$12.73</td> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row3_col1" class="data row3 col1" >3</td> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row3_col2" class="data row3 col2" >4.24333</td> 
    </tr>    <tr> 
        <th id="T_943a45fe_110b_11e8_8ae2_f200c432c501level0_row4" class="row_heading level0 row4" >Eoda93</th> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row4_col0" class="data row4 col0" >$11.58</td> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row4_col1" class="data row4 col1" >3</td> 
        <td id="T_943a45fe_110b_11e8_8ae2_f200c432c501row4_col2" class="data row4 col2" >3.86</td> 
    </tr></tbody> 
</table> 



Most Popular Items


```
purchase_df.head()
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Age</th>
      <th>Gender</th>
      <th>Item ID</th>
      <th>Item Name</th>
      <th>Price</th>
      <th>SN</th>
      <th>Age Demographics</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>38</td>
      <td>Male</td>
      <td>165</td>
      <td>Bone Crushing Silver Skewer</td>
      <td>3.37</td>
      <td>Aelalis34</td>
      <td>33-45</td>
    </tr>
    <tr>
      <th>1</th>
      <td>21</td>
      <td>Male</td>
      <td>119</td>
      <td>Stormbringer, Dark Blade of Ending Misery</td>
      <td>2.32</td>
      <td>Eolo46</td>
      <td>21-25</td>
    </tr>
    <tr>
      <th>2</th>
      <td>34</td>
      <td>Male</td>
      <td>174</td>
      <td>Primitive Blade</td>
      <td>2.46</td>
      <td>Assastnya25</td>
      <td>33-45</td>
    </tr>
    <tr>
      <th>3</th>
      <td>21</td>
      <td>Male</td>
      <td>92</td>
      <td>Final Critic</td>
      <td>1.36</td>
      <td>Pheusrical25</td>
      <td>21-25</td>
    </tr>
    <tr>
      <th>4</th>
      <td>23</td>
      <td>Male</td>
      <td>63</td>
      <td>Stormfury Mace</td>
      <td>1.27</td>
      <td>Aela59</td>
      <td>21-25</td>
    </tr>
  </tbody>
</table>
</div>




```
most_pop_items = pd.DataFrame(purchase_df.groupby('Item ID')["Item ID"].count())

most_pop_items.sort_values("Item ID", ascending = False, inplace=True)
most_pop_items = most_pop_items.iloc[0:6, :]

item_revenue = pd.DataFrame(purchase_df.groupby('Item ID')["Price"].sum())
item_revenue = item_revenue.rename(columns={'Price':'Revenue'})
top_5_items = pd.merge(most_pop_items, item_revenue, left_index=True, right_index=True)
top_5_items = top_5_items.rename(columns ={'Item ID':'Quantity Sold'})
no_duplicates = purchase_df.drop_duplicates(["Item ID"], keep = 'last')
top_5_merged = pd.merge(top_5_items, no_duplicates, left_index = True, right_on="Item ID")
top_5_merged = top_5_merged[["Item ID", 'Item Name', 'Quantity Sold', 'Revenue', 'Price']]
top_5_merged
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Item ID</th>
      <th>Item Name</th>
      <th>Quantity Sold</th>
      <th>Revenue</th>
      <th>Price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>721</th>
      <td>39</td>
      <td>Betrayal, Whisper of Grieving Widows</td>
      <td>11</td>
      <td>25.85</td>
      <td>2.35</td>
    </tr>
    <tr>
      <th>766</th>
      <td>84</td>
      <td>Arcane Gem</td>
      <td>11</td>
      <td>24.53</td>
      <td>2.23</td>
    </tr>
    <tr>
      <th>772</th>
      <td>31</td>
      <td>Trickster</td>
      <td>9</td>
      <td>18.63</td>
      <td>2.07</td>
    </tr>
    <tr>
      <th>761</th>
      <td>175</td>
      <td>Woeful Adamantite Claymore</td>
      <td>9</td>
      <td>11.16</td>
      <td>1.24</td>
    </tr>
    <tr>
      <th>765</th>
      <td>13</td>
      <td>Serenity</td>
      <td>9</td>
      <td>13.41</td>
      <td>1.49</td>
    </tr>
    <tr>
      <th>746</th>
      <td>34</td>
      <td>Retribution Axe</td>
      <td>9</td>
      <td>37.26</td>
      <td>4.14</td>
    </tr>
  </tbody>
</table>
</div>



Most Profitable Items


```
most_profit = pd.DataFrame(purchase_df.groupby("Item ID")["Price"].sum())
most_profit.sort_values("Price", ascending = False, inplace=True)
most_profit = most_profit.iloc[0:5, :]
profit_purch_count = pd.DataFrame(purchase_df.groupby('Item ID')['Item ID'].count())
most_profit = pd.merge(most_profit, profit_purch_count, left_index=True, right_index=True, how = 'left')
merge_most_profit = pd.merge(most_profit, no_duplicates, left_index=True, right_on ="Item ID", how='left')

merge_most_profit = merge_most_profit[['Item Name', 'Item ID_x', 'Price_y','Price_x']]
merge_most_profit.rename(columns = {'Item ID_x': 'Purchase Count', 'Price_y': 'Item Price', 'Price_x': 'Total Purchase Value'}, inplace = True)
merge_most_profit
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Item Name</th>
      <th>Purchase Count</th>
      <th>Item Price</th>
      <th>Total Purchase Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>746</th>
      <td>Retribution Axe</td>
      <td>9</td>
      <td>4.14</td>
      <td>37.26</td>
    </tr>
    <tr>
      <th>705</th>
      <td>Spectral Diamond Doomblade</td>
      <td>7</td>
      <td>4.25</td>
      <td>29.75</td>
    </tr>
    <tr>
      <th>657</th>
      <td>Orenmir</td>
      <td>6</td>
      <td>4.95</td>
      <td>29.70</td>
    </tr>
    <tr>
      <th>716</th>
      <td>Singed Scalpel</td>
      <td>6</td>
      <td>4.87</td>
      <td>29.22</td>
    </tr>
    <tr>
      <th>779</th>
      <td>Splitter, Foe Of Subtlety</td>
      <td>8</td>
      <td>3.61</td>
      <td>28.88</td>
    </tr>
  </tbody>
</table>
</div>



Observable Trends:
1. This game is primarily played by males, who represent over 80% of players
2. A good age group to target is the 21-25 group. They by far have the highest quanity of purchases and 
   spend the most in total.
3. Only 1 of the most profitable items are in the top 6 most popular items
