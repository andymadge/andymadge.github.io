---
title: Elasticsearch Crib Sheet
header:
  image: assets/images/header-images/IMG_6898_w2500.jpeg
categories:
  - Crib Sheets
tags:
  - elasticsearch
toc: true
---
## General
* All inputs are JSON documents, however the format does allows comments (C-style, `/* */`)
* add `?v` to include column headers in table output
* add `?pretty` to pretty print JSON output (rather than all on 1 line)
* Important pages to read:
    * <https://www.elastic.co/guide/en/elasticsearch/reference/5.6/important-settings.html#path-settings>


## Indices
* In Elastic Search terminology, the plural of 'Index' is 'Indices', NOT 'Indexes'
* There are a few properties that you must set correctly for indexes:
    * mappings
    * shard counts
    * replicas, etc

### Useful APIs

#### List indices:
```
GET _cat/indices?v
```

#### Display settings for all indices:
```
GET _settings/
```

#### Display settings for a specific index:
```
GET syslog-2018.12.08/_settings/
```

#### Display just some settings instead of all:
```
GET _settings/*shards,*replicas
```

#### Modify settings for a specific index:
```json
PUT syslog-2018.12.08/_settings
{
  "index": {
    "number_of_replicas": "0",
    "number_of_shards": "1"
  }
}
```
NOTE: this will fail because both of those settings can only be modified for a closed index. See [Templates section](#templates) below for the correct way to set these.


## Shards
* By default, each index in Elasticsearch is allocated 5 primary shards and 1 replica which means that if you have at least two nodes in your cluster, your index will have 5 primary shards and another 5 replica shards (1 complete replica) for a total of 10 shards per index. — from <https://www.elastic.co/guide/en/elasticsearch/reference/5.6/_basic_concepts.html>
* The number of shards should be chosen so that each shard is less than 50GB in size
* There is a soft limit of 1000 shards per node (this is configurable)
* If you're on a single node, there is no point in having more than 1 shard per index
    * Therefore you'll need to change the default 
* You can monitor shard sizes using the `/_cat/shards` API:

  ### List all shards
    ```
    GET _cat/shards?v
    ```


## Replicas
* If you leave this on the default of 1, everything will work fine, however your index status will NEVER go green, it will always stay yellow because you have asked for a replica but the cluster cannot deliver a replica if there is only 1 node.
* Therefore if you have only 1 node, you should set replicas to 0 for all indexes.


## Templates
* A template is a set of settings and mappings that get used when creating a new index
    * Therefore the template is only applied at index creation. If you modify a template, it doesn't affect previously created indices
* The API is `/_template`
* See <https://www.elastic.co/guide/en/elasticsearch/reference/5.6/indices-templates.html>
* Templates have a pattern which controls which indices they apply to. If the index name matches the template pattern, then the template is used when creating that index
    * If multiple templates match an index name, then they all get applied. When there is a conflict, the 'order' fields of the templates control which wins. Higher value in order field wins.

### Set default template

#### Check current values:
```
GET _template/default
```
Will return empty if there is no default

#### Set it:
```json
POST _template/default
{
  "template": "*",
  "order": -1,
  "settings": {
    "number_of_shards": "1",
    "number_of_replicas": "0"
  }
}
```

## Mappings
* A mapping is kind of like a schema or table; it is a set of field definitions (this analogy breaks down quickly so don't make too many assumptions based on it)
* In the API URL, it is `/<index>/<mapping>` so `/twitter/tweets` references the 'twitter' index and the 'tweets' mapping
* The mapping is defined when the index is created, and it can't be modified afterwards. 
    * You can ADD a mapping to an index, but you can't modify and existing mapping
    * If you want to change a mapping, you need to create a new index with the new mapping, then use the reindex API to copy the data to the new index
* Each index can have multiple mappings
    * NOTE: This is being removed in Elastic Search 6.0
    * You can use setting index.mapping.single_type: true to make v5.6 behave like 6.0+ will behave.
* Different documents in an index can have different mappings
* If a field name is used in multiple mappings, it must use the same type in each of them.
    * E.g. if you have a field called 'deleted'  date in one mapping, then you can't have a field with same name that is a boolean in another mapping. It must be the same type on both mappings


## Tips
* For timeseries data, it's a good idea to disable indexing of the numeric fields, since you're like you want to aggregate those fields but unlikely to filter them. See <https://www.elastic.co/guide/en/elasticsearch/reference/5.6/dynamic-templates.html#_time_series>


## Specific Tasks


### Create and Delete indices

#### View index:
```
GET tempmon-2016*
```

#### Create index:
```
PUT tempmon-2016
```

#### Delete index:
```
DELETE tempmon-2016
```


### Combine indices
e.g. Combine `tempmon-2016.10`, `tempmon-2016.11`, `tempmon-2016.12` into a single index `tempmon-2016`

#### View the indices:
```
GET tempmon-2016*
```

Ensure there is an appropriate template that sets things like shards and replicas.  Test the template works by creating and then viewing a new index (just give it a random name then delete it)

#### Do the reindex:
```json
POST _reindex?pretty
{
    "conflicts": "proceed",
    "source": {
        "index": "tempmon-2016*"
    },
    "dest": {
        "index": "tempmon-2016",
        "op_type": "create"
    }
}
```

NOTE: This can take a while to run, so if you run it in Kibana Dev Tools it will probably time out. However, the reindex will continue in the background.
Alternatively you can run the command from the terminal. Click the spanner in Kibana and "Copy as cURL" to get it in the right format.

#### To monitor the creation of the new index:
```
GET tempmon-2017/_stats
```

The total document count is:
```
  "_all": {
    "primaries": {
      "docs": {
        "count": 243157,
```

#### You can get status for multiple indices like this:
```
GET tempmon-2017.*/_stats
```
this will list all matching indices, but at the top will be the _all section which aggregates all the indices and should match the above number.

#### Finally, delete the old indices:
```
DELETE tempmon-2017.*
```