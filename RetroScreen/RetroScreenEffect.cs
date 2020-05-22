using UnityEngine;

[ExecuteInEditMode]
public class RetroScreenEffect : CustomImageEffectBase
{
    #region Fields
    [SerializeField]
    private float Pixelate = 100.0f;
    [SerializeField]
    [Range(1, 256)]
    private int PosterizeColor = 1;
    [SerializeField]
    private float Hue = 0.0f;
    [SerializeField]
    private float Saturation = 1.0f;

    #endregion

    #region Properties

    public override string ShaderName
    {
        get { return "CustomFilter/RetroScreen"; }
    }

    #endregion

    #region Methods

    protected override void UpdateMaterial()
    {

        Material.SetFloat("_Pixelate", Pixelate);
        Material.SetInt("_Posterize", PosterizeColor);
        Material.SetFloat("_Hue", Hue);
        Material.SetFloat("_Saturation", Saturation);


    }

    #endregion

}

