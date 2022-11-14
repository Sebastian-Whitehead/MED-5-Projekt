using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FadeScreen : MonoBehaviour
{
    public bool fadeOnStart = true;
    public float defaultFadeDuration = 2;
    public Color fadeColor;
    private Renderer _rend;
    private static readonly int Color1 = Shader.PropertyToID("_Color");

    // Start is called before the first frame update
    void Start()
    {
        _rend = GetComponent<Renderer>();
        if (fadeOnStart)
            FadeIn();
    }

    public void Fade(float alphaIn, float alphaOut)
    {
        StartCoroutine(FadeRoutine(alphaIn, alphaOut, defaultFadeDuration));
    }
    
    public void Fade(float alphaIn, float alphaOut, float fadeDuration)
    {
        StartCoroutine(FadeRoutine(alphaIn, alphaOut, fadeDuration));
    }

    public void FadeIn()
    {
        Fade(1,0);
    }

    public void FadeOut()
    {
        Fade(0,1);
    }

    public IEnumerator FadeRoutine(float alphaIn, float alphaOut, float fadeDuration)
    {
        float timer = 0;
        while (timer <= fadeDuration)
        {
            Color newColor = fadeColor;
            newColor.a = Mathf.Lerp(alphaIn, alphaOut, timer / fadeDuration);
            _rend.material.SetColor(Color1, newColor);
            
            timer += Time.deltaTime;
            yield return null;
        }
        Color newColor2 = fadeColor;
        newColor2.a = alphaOut;
        _rend.material.SetColor("_Color", newColor2);
        
    }
}
