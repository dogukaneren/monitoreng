# monitoreng
The script records the CPU, RAM, and Swap usage of the device at specified intervals and stores the maximum and minimum data accessed during its runtime. Additionally, it generates logs when predetermined thresholds are exceeded.

# Usage
``` bash
chmod +x monitoreng.sh
./monitoreng.sh
```
Program produces output on /opt/monitoreng

``` bash
ls /opt/monitoreng 
max-min-values.txt  values.txt
```

``` bash
cat /opt/monitoreng/max-min-values
Max-CPU-Value: 7%
Min-CPU-Value: 0%
Max-RAM-Value: 12%
Min-RAM-Value: 10%
Max-Swap-Value: 0%
Min-Swap-Value: 0%
```

```bash
cat /opt/monitoreng/values
Date: 2023-11-10_01-04-50
CPU Usage: 7%
RAM Usage: 12%
Swap Usage: 0%
---
Date: 2023-11-10_01-04-54
CPU Usage: 3%
RAM Usage: 12%
Swap Usage: 0%
---
Date: 2023-11-10_01-04-57
CPU Usage: 2%
RAM Usage: 12%
Swap Usage: 0%
---
Date: 2023-11-10_01-05-00
CPU Usage: 1%
RAM Usage: 12%
Swap Usage: 0%
---
Date: 2023-11-10_01-05-03
CPU Usage: 3%
RAM Usage: 12%
Swap Usage: 0%
---

```

