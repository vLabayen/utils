# passgen

Options:  
```
  -l / --length     : Password length. Default 30
  -a / --alphabet   : Password alphabet.
                      Default: qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890!¡()?¿{}[]<>|@#$%&/=+*-_.:;,
```

Examples:  
```bash
>> ./passgen.py  
,0k2D@:Y/3$Nrn:8F72MD|iWXB[DhP  
```

```bash
>> ./passgen.py -l 50  
o,{TU9Cw?,.NY<CkOlZ8<-fM:_F6-MPK:J|A0*v0ZA1AXxqKCf  
```

```bash
>> ./passgen.py -a 0123456789abcdef
442d11eea9cf478b582f4cbcd7f41e
```

```bash
>> ./passgen.py -l 50 -a 0123456789abcdef
7d2b28180ec957d57220494e0601819b6c2d6d41706628d93e
```
