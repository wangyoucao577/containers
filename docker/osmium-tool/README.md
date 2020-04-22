# osmium-tool
![Build Docker - osmium-tool](https://github.com/wangyoucao577/containers/workflows/Build%20Docker%20-%20osmium-tool/badge.svg)      
Docker image to wrap [osmium-tool](https://github.com/osmcode/osmium-tool) that can be used like a command line tool.     
Please be noted that the `libosmium` clones from [wangyoucao577/libosmium](https://github.com/wangyoucao577/libosmium) instead of the official repo [osmcode/libosmium](https://github.com/osmcode/libosmium), which has increased the `max_osm_string_length` to support long PBF tags. See more details in [#1](https://github.com/wangyoucao577/libosmium/pull/1).     
 
## Build Image
- [Dockerfile](./Dockerfile)

```bash
$ cd docker/osmium-tool
$ docker build -t wangyoucao577/osmium-tool .  
```

## Pull Image 
### DockerHub
[DockerHub Repo: wangyoucao577/osmium-tool](https://hub.docker.com/r/wangyoucao577/osmium-tool)    
```bash
$ docker pull wangyoucao577/osmium-tool
```

### Github Package
[Github Package Repo: docker.pkg.github.com/wangyoucao577/containers/osmium-tool](https://github.com/wangyoucao577/containers/packages/193791)

```bash
$ docker pull docker.pkg.github.com/wangyoucao577/containers/osmium-tool
```

## Run container as Command Line Tool

```bash
# same behavior with `osmium -h`
$ docker run --rm wangyoucao577/osmium-tool -h
Usage: osmium COMMAND [ARG...]
       osmium --version

COMMANDS:
  add-locations-to-ways   Add node locations to ways
  apply-changes           Apply OSM change files to OSM data file
  cat                     Concatenate OSM files and convert to different formats
  changeset-filter        Filter OSM changesets by different criteria
  check-refs              Check referential integrity of an OSM file
  create-locations-index  Create node locations index on disk
  derive-changes          Create OSM change files from two OSM data files
  diff                    Display differences between OSM files
  export                  Export OSM data
  extract                 Create geographic extract
  fileinfo                Show information about OSM file
  getid                   Get objects with given ID from OSM file
  getparents              Get parents of objects from OSM file
  help                    Show osmium help
  merge                   Merge several sorted OSM files into one
  merge-changes           Merge several OSM change files into one
  query-locations-index   Query node locations index on disk
  renumber                Renumber IDs in OSM file
  show                    Show OSM file contents
  sort                    Sort OSM data files
  tags-count              Count OSM tags
  tags-filter             Filter OSM data based on tags
  time-filter             Filter OSM data from a point in time or a time span out of a history file

TOPICS:
  file-formats           File formats supported by Osmium
  index-types            Index types for storing node locations

Use 'osmium COMMAND -h' for short usage information.
Use 'osmium help COMMAND' for detailed information on a specific command.
Use 'osmium help TOPIC' for detailed information on a specific topic.
```


## Author
wangyoucao577@gmail.com
