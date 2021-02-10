<div align="center">
<pre>
'||' '|'     |     '||''|.   '||''''|  '||' '|'
  || |      |||     ||   ||   ||  .      || |
   ||      |  ||    ||'''|.   ||''|       ||
   ||     .''''|.   ||    ||  ||         | ||
  .||.   .|.  .||. .||...|'  .||.....| .|   ||.



</pre>
</div>

---

<p align="center">
<sup>01011001 01000001 01000010 01000101 01011000</sup>
</p>

---

<em>**WORK IN PROGRESS**: A Vim buffer viewer.</em>

NB! This is experimental and has known bugs and limitations.

Open with `:YabexOpen` or create a map for it. You could uncomment `call s:set_maps()` in `plugin/plugin.vim`

Once open it list all buffers + most hidden.

Gutter show window, list shows buffer number. If one buffer is open in multiple windows, (usually) the last accessed is displayed.

Color codes (see [Sample Images](#sample-images)):

* Current and Alt Window window have separate colors
* Current and Alt buffer have different colors

## Actions

Position the cursor on a file and:

|  Key | Action |
| :---: | --- |
| <kbd>Enter</kbd> | Open file in last window |
| <kbd>&lt;Leader&gt;Enter</kbd> | Open file in last window and set focus |
| <kbd>&lt;NR&gt;Enter</kbd> | Open file in window &lt;NR&gt; |
| <kbd>&lt;NR&gt;&lt;Leader&gt;Enter</kbd> | Open file in window &lt;NR&gt; and set focus |
| `o` | Open file in last window |
| `O` | Open file in last window and set focus |
| `<NR>o` | Open file in window &lt;NR&gt; |
| `<NR>O` | Open file in window &lt;NR&gt; and set focus |
| | |
| `e` | Open `:Explore` in path for file under cursor  |
| `t` | Open `:terminal` in path for file under cursor |
| `d` | Do git diff for file under cursor<br>**Note:** The diff is opened in a sratch buffer which is re-used on next diff. New diffs are appended to the buffer. Anything can be overwritten or lost on new diffs. |


## Sample images


### Sample 1

<p align="center">
<img src="https://raw.githubusercontent.com/Termplexed/res/master/img/yabex-sample-1.png" />
<table align=center>
  <tr>
    <th> Here windows are:</th>
    <th> Buffers:</th>
  </tr>
  <tr>
    <td>

`1`. The Yabex window

`2`. The alternate window (Ctrl+W p)

`3`. Current window
</td><td>

`7`. Current buffer

`5`. Alternate buffer for current window (:b#)

`3`. Buffer visible in window 2

</td>
</tr>
</table>
</p>

<hr/>


### Sample 2


<p align="center">
<img src="https://raw.githubusercontent.com/Termplexed/res/master/img/yabex-sample-3.png" />
<table align=center>
  <tr>
    <th> Here windows are:</th>
    <th> Buffers:</th>
  </tr>
  <tr>
    <td>

`1`. The Yabex window - Current

`2`. The alternate window (Ctrl+W p) – ***And*** current target for e.g. Enter, o etc.

`3`. Window 3
</td><td>

`1`. Alternate buffer for window 2

`4`. Current buffer for window 2

`5`. Current file in window 3

</td>
</tr>
</table>
</p>




